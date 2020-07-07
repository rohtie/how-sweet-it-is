float box(vec2 p, vec2 b) {
    return length(max(abs(p) - b, 0.)) - 0.0;
}

mat2 rotate(float a) {
    a *= acos(-1.);
    return mat2(-sin(a), cos(a),
                 cos(a), sin(a));
}

float r(vec2 p) {
    float r = 1.;

    {
        vec2 p = p;
        p.x += 0.01;
        p.y -= 0.0275;
        p *= rotate(0.5);
        r = min(r, box(p, vec2(0.075, 0.250)));
    }

    {
        vec2 p = p;
        p.x -= 0.21;
        p.y -= 0.139;
        p *= rotate(0.25);
        r = min(r, box(p, vec2(0.0975, 0.0975)));
    }

    return r;
}

// float o(vec2 p) {
//     float r = 1.;

//     p *= rotate(0.25);
//     r = min(r, box(p, vec2(0.125, 0.125)));

//     return r;
// }

float h(vec2 p) {
    float r = 1.;

    {
        vec2 p = p;
        p.x += 0.205;
        p.y -= 0.105;
        p *= rotate(0.25);
        r = min(r, box(p, vec2(0.125, 0.075)));
    }

    {
        vec2 p = p;
        p.y -= 0.266;
        p.x += 0.274;
        p *= rotate(0.0);
        r = min(r, box(p, vec2(0.125, 0.075)));
    }    

    {
        vec2 p = p;
        p.y += 0.162;
        p.x -= 0.122;

        r = min(r, box(p, vec2(0.075, 0.125)));
    }    

    {
        vec2 p = p;
        p.x += 0.099;
        p.y += 0.071;
        p *= rotate(-0.25);
        r = min(r, box(p, vec2(0.125, 0.075)));
    }    

    return r;
}

float i(vec2 p) {
    float r = 1.;

    {
        vec2 p = p;
        p.y += 0.187;
        p.x += 0.166 - 0.075 * 2.;
        r = min(r, max((p * rotate(-0.25)).y - 0.05, box(p, vec2(0.075, 0.15))));

        p.y -= 0.35;
        r = min(r, max((p * rotate(0.25)).y, box(p, vec2(0.075, 0.075))));
    }

    return r;
}

float e(vec2 p) {
    float r = 1.;

    {
        vec2 p = p;

        p.y -= 0.013;
        p.x -= 0.15;
        r = min(r, max((p * rotate(0.25)).y, box(p, vec2(0.075, 0.075))));

        p.y += 0.112 + 0.075;
        r = min(r, box(p, vec2(0.075, 0.075 * .5)));
    }

    return r;
}

float rohtie(vec2 p) {
    float re = 1.;

    p *= 1.5;

    p.y += sin(p.x + tan(p.y * 5. + time) + time * 2.) * .01;
    p.x += tan(p.x * 2. * sin(p.y * 200. + time) + sin(p.x * 20. + time + tan(p.y * 20. + time))) * .0002;    

    p.y += tan(abs(p.x - tan(p.y * 1.5)) * 4. + time + sin(p.y * 0.55) * 5.5 + cos(p.y * 2.) * 0.29) * .002;

    p.x -= 0.035;

    re = min(re, r(p - vec2(-0.75, 0.)));
    re = min(re, h(p - vec2(-0.055, -0.001)));
    re = min(re, i(p - vec2(0.38, 0.)));
    re = min(re, e(p - vec2(0.5145, 0.)));

    return re;
}

vec4 pixel(vec2 p) {
    p /= resolution;
    p -= .5;
    p.x *= resolution.x / resolution.y;

    float trans = max(1., 150. - time * 60.);
    float trans2 = max(0., 50. - time * 7.);

    p.x /= trans;
    p.y /= 0.9  + trans * 0.1;

    float re = rohtie(p);

    vec3 e = vec3(1., -1.,0.) * 0.002;

    float x1 = step(rohtie(p + e.xz), 0.);
    float y1 = step(rohtie(p + e.zy), 0.);
    float y2 = step(rohtie(p - e.zy), 0.);
    float x2 = step(rohtie(p - e.xz), 0.);

    vec2 normal = normalize(vec2(x1 - x2, y1 - y2)) * 10.;

    vec2 light = normalize(vec2(sin(time), cos(time)));
    float diffuse = dot(normal, light);
    diffuse = smoothstep(0., 1., diffuse);

    float shad = rohtie(p - light * .5 * abs(p.x * 0.9));
    shad = (2. + abs(p.x)) * .35 + smoothstep(0., 0.05 + abs(p.x * 2.) * 0.4, shad);

    float mre = step(re, 0.0);
    re = smoothstep(0., 0.0 + abs((p.x + sin(time * .15) * 1.1) * .05) * 2.5, re);



    vec4 bg = vec4(1.0, 0., 0., 0.);
    bg += vec4(p.y * trans2, p.y * trans2 * 0.278, p.y * trans2 * 0.1, 0.);


    return bg * (1. - diffuse) * shad + mre * (1. - diffuse);
}
