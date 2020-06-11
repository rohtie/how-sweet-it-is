float smin(float a, float b, float k) {
    float ka = exp2(-k * a);
    float kb = exp2(-k * b);

    return -log(ka + kb) / k;
}

mat2 rotate(float a) {
    a *= acos(-1.);
    return mat2(-sin(a), cos(a),
                 cos(a), sin(a));
}

float map(vec3 p) {

    // p.xz *= rotate(-0.35);
    // p.xz *= rotate(0.35);
    // p.xz *= rotate(0.2);
    p.zy *= rotate(0.35);
    p.xz *= rotate(time * .06);



    float r = 1000.;

    // Stomach
    {
        vec3 p = p;
        r = min(r, length(p) - 4.9);
    }

    // upper body
    {
        vec3 p = p;

        p.y -= 5.5;
        p.z += 3.5;
        r = smin(r, length(p) - 3., 2.);

        p.x = abs(p.x);

        p.xz *= rotate(0.6);

        p.y -= 1.8;
        p.z += 4.5;

        r = smin(r, length(p) - 4.5, 2.);
    }

    // shoulders
    {
        vec3 p = p;

        p.x = abs(p.x);

        p.y -= 9.8;
        p.z += 10.5;
        p.x -= 5.;

        r = smin(r, length(p) - 2.5, 2.);
    }    

    // neck
    {
        vec3 p = p;

        p.y -= 10.8;
        p.z += 12.5;

        r = smin(r, length(p) - 1.5, 2.);
    }

    // boobs 
    {
        vec3 p = p;

        p.x = abs(p.x);

        p.y -= 2.2;
        p.z += 9.5;
        p.x -= 2.75;

        r = smin(r, length(p) - 2.1, 2.5);


        p.z += 0.75;
        p.y += 2.5;

        r = smin(r, length(p) - 0.2, 2.6);
    }    


    // ass cheeks
    {
        vec3 p = p;

        p.x = abs(p.x);

        p.x -= 3.2;
        p.y += 2.;
        p.z -= 2.5;

        r = smin(r, length(p) - 4.75, 4.);
        
        p.y += 0.4;
        p.z -= 2.25;
        p.x += 0.75;
        r = smin(r, length(p) - 3.65, 4.);
    }

    // Thighs
    // {
    //     vec3 p = p;

    //     p.x = abs(p.x);

    //     p.z += 5.;
    //     p.y += 6.65;
    //     p.x -= 3.75;

    //     p.zy *= rotate(-.32);
    //     p.zx *= rotate(-.51);

    //     float part = length(max(abs(p) - vec3(0., 0., 4.25), 0.)) - 2.5 - p.z * .1;

    //     r = smin(r, part, 4.);
    // }

    return r * 5.;
}

vec4 pixel(vec2 p) {
    p /= resolution.xy;
    p = 2.0 * p - 1.0;
    p.x *= resolution.x / resolution.y;

    vec3 cam = vec3(0., 0., 27.);
    vec3 ray = vec3(p, -1.);

    float dist = 0;
    for (int i=0; i<250; i++) {
        vec3 p = cam + ray * dist;

        float tmp = map(p);

        if (tmp < 0.001) {
            vec3 light = normalize(vec3(12., -5., -10.));

            float shade = map(p - light * 1.5);
            return vec4(1., 1., 1., 0.) * shade;
        }

        dist += tmp;

        if (dist > 50.) {
            break;
        }
    }

    return vec4(0.4);
}
