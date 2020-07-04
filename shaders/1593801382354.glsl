mat2 rotate(float a) {
    a *= acos(-1.);

    return mat2(-sin(a), cos(a),
                 cos(a), sin(a));
}

float smin(float a, float b, float k) {
    float ka = exp2(-k * a);
    float kb = exp2(-k * b);

    return -log2(ka + kb) / k;
}

float hashie(vec2 p) {
    return sin(p.x * 05. + sin(p.y * 200.) * 100. + p.x * p.y * 1000.);
}


float water(vec3 p) {
    float r = 1.;

    float cylinder = length(max(abs(p) - vec3(0., 20., 0.), 0.)) - 1.01 - sin(p.y * 4.6 + time * 18.) * .005;
    cylinder = max(-cylinder, cylinder - 0.01);

    float mask = 1.;
    
    p.xz *= rotate(0.25);
    mask = min(mask, abs(p.x) - .175);
    
    p.xz *= rotate(0.2);
    mask = min(mask, abs(p.x) - .08);

    p.xz *= rotate(0.8);
    mask = min(mask, abs(p.x) - .28);    

    cylinder = max(cylinder, mask);

    r = min(r, max(cylinder, abs(p.y + 0.6) - .6));
    r = min(r, max(abs(p.y) - 0.01, length(p) - 1.04));
    p.y += 1.;
    r = smin(r, max(abs(p.y) - 0.01, length(p) - 5.), 20.);    

    return r;
}

float fountain(vec3 p) {
    p.y *= 2.;

    float r = max(p.y, length(p) - 1. - sin(p.y * 20. + time * 5.) * .005);
    p.y += 0.05;
    r = min(r, max(-p.y - 1.05, length(p - vec3(0., -1., 0.)) - .2));

    p.y += 1.4;
    r = min(r, length(max(abs(p) - vec3(0.0, .3, 0.0), 0.)) - 0.18 + p.y * .12 - sin(p.y * 25. + time * 1.1) * .0075 - sin(atan(p.x, p.z) * 15.) * .02);

    p.y -= 0.75;
    r = min(r, max(-p.y - 1.3, length(p - vec3(0., -1.95, 0.)) - 0.9 - sin(time * 1.5 + p.y * 25.) * 0.02 - sin(atan(p.x, p.z) * 25.) * .02));

    return r * .4;
}


float map(vec3 p) {
    return min(water(p), fountain(p));
}

vec4 pixel(vec2 p) {
    p /= resolution;
    vec2 q = p;
    p -= .5;
    p.x *= resolution.x / resolution.y;

    vec3 cam = vec3(0., 0., 4.);
    vec3 ray = vec3(p, -1.);

    cam.zx *= rotate(time * .04 + 1.05);
    ray.zx *= rotate(time * .04 + 1.05);
    cam.xy *= rotate(0.4);    
    ray.xy *= rotate(0.4);    

    float dist = 0.;

    for (int i=0; i<100; i++) {
        vec3 p = cam + ray * dist;

        float tmp = map(p);

        if (tmp < 0.001) {
            vec3 light = normalize(p - vec3(4., -0.5, 5.));

            float shade = map(p - light);

            if (water(p) == tmp) {
                // q.x += 0.002;
                // q.y += 0.002;
                // return texture(channel0, q);
                // return 0.03 + texture(channel0, q) * vec4(1., 1.4, 1.2, 1.);                
                return vec4(0., 0.14, 1.5, 0.) + shade * 1.75;
            }

            if (fountain(p) == tmp) {
                float ring = 1. - smoothstep(0., 0.001, abs(p.y + 0.52) - 0.04);
                return vec4(shade * 2.) * vec4(p.y * .35 + 1.35 + ring * 1.25 + mod(p.y, 0.075) * 5., 0.9 + ring * 1.2 - mod(p.y + 0.31 + sin(p.x * 14. + time * 6.5) * .005, 0.075) * 5., 2.2 - ring, 0.);
            }

            return vec4(shade);
        }

        dist += tmp;
    }


    return vec4(0.);
}
