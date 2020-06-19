

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
        p.x -= 0.1145;
        p.y += 0.0955;
        p *= rotate(-0.25);
        r = min(r, box(p, vec2(0.075, 0.325)));
    }

    {
        vec2 p = p;
        p.x -= 0.169;
        p.y -= 0.1615;
        p *= rotate(0.0);
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
        p.y -= 0.27;
        p.x += 0.27;
        p *= rotate(0.0);
        r = min(r, box(p, vec2(0.125, 0.075)));
    }    

    {
        vec2 p = p;
        p.x += 0.097;
        p.y += 0.075;
        p *= rotate(-0.25);
        r = min(r, box(p, vec2(0.125, 0.075)));
    }    

    return r;
}

float rohtie(vec2 p) {
    float re = 420.;

    re = min(re, r(p - vec2(-0.5, 0.)));
    // re = min(re, o(p - vec2(-0.15, -0.04)));
    re = min(re, h(p - vec2(0.2, 0.)));

    return re;
}


vec4 pixel(vec2 p) {
    p /= resolution;
    p -= .5;
    p.x *= resolution.x / resolution.y;

    float re = rohtie(p);
    re = smoothstep(0., 0.0055, re);

    return vec4(1., 0.0, 0.0, 0.) * re;
}
