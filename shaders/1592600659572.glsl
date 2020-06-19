

float box(vec2 p, vec2 b) {
    return length(max(abs(p) - b, 0.)) - 0.0;
}

mat2 rotate(float a) {
    a *= acos(-1.);
    return mat2(-sin(a), cos(a),
                 cos(a), sin(a));
}

float r(vec2 p) {
    float r = 420.;

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

float o(vec2 p) {
    float r = 420.;

    p *= rotate(0.25);
    r = min(r, box(p, vec2(0.125, 0.125)));

    return r;
}

float h(vec2 p) {
    float r = 420.;

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
        p.y += 0.072;
        p *= rotate(-0.25);
        r = min(r, box(p, vec2(0.125, 0.075)));
    }    

    return r;
}

float i(vec2 p) {
    float r = 420.;

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

float rohtie(vec2 p) {
    float re = 420.;

    p.x += 0.05;

    re = min(re, r(p - vec2(-0.75, 0.)));
    // re = min(re, o(p - vec2(-0.248, -0.04)));
    re = min(re, h(p - vec2(-0.055, -0.001)));
    // re = min(re, t(p - vec2(0.545, 0.)));
    re = min(re, i(p - vec2(0.38, 0.)));

    return re;
}


vec4 pixel(vec2 p) {
    p /= resolution;
    p -= .5;
    p.x *= resolution.x / resolution.y;

    // p.y += sin(p.x + tan(p.y * 5. + time) + time * 2.) * .01;
    // p.x += tan(p.x * 2. * sin(p.y * 200. + time) + sin(p.x * 20. + time + tan(p.y * 20. + time))) * .0002;
    float re = rohtie(p);
    // re = smoothstep(0., 0.0 + abs((p.x + sin(time * .15) * 1.1) * .05) * 2.5, re);
    re = step(re, 0.0);

    return vec4(1., 0.0, 0.0, 0.) * re;
}
