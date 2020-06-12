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


    p.y += sin(p.x * 0.1 + time * 10. + cos(p.x * 0.5 + time) * .75) * .4;
    p.y += sin(p.z * 0.2 + time * 5.) * .7;


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

    // Thigs + legs + feet
    {
        vec3 p = p;

        p.x = abs(p.x);

        p.z += 0.5;
        p.y += 11.65;
        p.x -= 4.15;

        p.yx *= rotate(-0.47);
        p.zy *= rotate(0.42);

        float part = length(max(abs(p) - vec3(0., 8.25, 0.), 0.)) - 4.;
        r = smin(r, part, 1.8);

        p.y += 27.;
        p.z += 5.5;
        p.x += 2.;


        p.yx *= rotate(-0.48);
        p.zy *= rotate(0.40);

        part = length(max(abs(p) - vec3(0., 17.25, 0.), 0.)) - 4.;
        r = smin(r, part, 1.8);   


        // p.yx *= rotate(-0.48);
        // p.zy *= rotate(0.40);

        // p.y += 20.;

        // part = length(max(abs(p) - vec3(0., 0., 10.), 0.)) - 4.;
        // r = smin(r, part, 1.8);   


    }

    return r * 8.;
}

vec4 pixel(vec2 p) {
    p /= resolution.xy;
    p = 2.0 * p - 1.0;
    p.x *= resolution.x / resolution.y;

    vec3 cam = vec3(0., -5., 27.);
    vec3 ray = vec3(p, -1.);

    float dist = 0;
    for (int i=0; i<250; i++) {
        vec3 p = cam + ray * dist;

        float tmp = map(p);

        if (tmp < 0.001) {
            float greenShade = map(p - normalize(vec3(12., -5., -10.)) * 1.5);
            float redShade = map(p - normalize(vec3(-12., 5., -4.)) * 1.5);
            float blueShade = map(p - normalize(vec3(20., -15., 10.)) * 1.5);
            
            return vec4(redShade, greenShade * 1.3, blueShade * 2.5, 0.) * tan(time * 24.);
        }

        dist += tmp;

        if (dist > 90.) {
            break;
        }
    }

    return vec4(0.4);
}
