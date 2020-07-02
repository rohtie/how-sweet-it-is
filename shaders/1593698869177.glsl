vec4 pixel(vec2 p) {
    p /= resolution;
    vec2 q = p;

    p -= 0.5;
    p.x *= resolution.x / resolution.y;

    // return vec4(time - 13.);

    p.y += sin(p.x);
    p.y += (sin(p.x * 5.)) * .15;

    if (abs(p.y) < (1. - (time - 12.7) * 0.5) * 1.65) {
        return texture(channel1, q);
    }

    q.x -= 0.001;
    return (texture(channel0, q) + 0.01) * vec4(.98, .9, 1.5, 0.);
}
