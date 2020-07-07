vec4 pixel(vec2 p) {
    p /= resolution;
    vec2 q = p;

    p -= 0.5;
    p.x *= resolution.x / resolution.y;

    p.y += sin(p.x);
    p.y += (sin(p.x * 5.)) * .15;

    vec4 intro = texture(channel1, q);

    p.y += intro.r * 0.6;

    if (abs(p.y) < (1. - ((time + tan(p.x * 1. + time * 30.) * .2) - 12.7) * 0.18) * 1.65) {
        return intro * tan(time * 37.);
    }

    q.x -= 0.001;
    q.y *= 0.98;
    q.y += 0.01;

    vec4 self = texture(channel2, q);
    
    return (self + 0.01) * vec4(.98, .9 - tan(p.x * 0.7), 1.5, 0.);
}
