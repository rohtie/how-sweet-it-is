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


float fountain(vec3 p) {
    p.y *= 2.;

    float r = max(p.y, length(p) - 1.);
    p.y += 0.05;
    r = min(r, max(-p.y - 1.05, length(p - vec3(0., -1., 0.)) - .2));

    p.y += 1.4;
    r = min(r, length(max(abs(p) - vec3(0.0, .3, 0.0), 0.)) - 0.18 + p.y * .12 - sin(p.y * 25. + time * 1.1) * .0075 - sin(atan(p.x, p.z) * 15.) * .02);

    p.y -= 0.75;
    r = min(r, max(-p.y - 1.3, length(p - vec3(0., -1.95, 0.)) - 0.9 - sin(time * 1.5 + p.y * 25.) * 0.02 - sin(atan(p.x, p.z) * 25.) * .02));

    return r * .4;
}


float map(vec3 p) {
    return fountain(p);
}

vec4 pixel(vec2 p) {
    p /= resolution;
    vec2 q = p;
    p -= .5;
    p.x *= resolution.x / resolution.y;

    vec3 cam = vec3(0., 0., 4.);
    vec3 ray = vec3(p, -1.);

    cam.zx *= rotate(time * .04 + 1.75);
    ray.zx *= rotate(time * .04 + 1.75);
    cam.zy *= rotate(0.3);    
    ray.zy *= rotate(0.3);    

    float dist = 0.;

    for (int i=0; i<100; i++) {
        vec3 p = cam + ray * dist;

        float tmp = map(p);

        if (tmp < 0.001) {
            vec3 light = normalize(p - vec3(4., -0.5, 5.));

            float shade = map(p - light);

            if (fountain(p) == tmp) {

                if (p.y > 0.0) {
                    q.x += 0.002;
                    q.y += 0.002;
                    return 0.03 + texture(channel0, q) * vec4(1., 1.4, 1.2, 1.);
                }

                float ring = 1. - smoothstep(0., 0.001, abs(p.y + 0.52) - 0.04);
                return vec4(shade * 2.) * vec4(p.y * .35 + 1.35 + ring * 1.25, 0.9 + ring * 1.2, 2.2 - ring, 0.);
            }

            return vec4(shade);
        }

        dist += tmp;
    }


    return vec4(0.);
}
