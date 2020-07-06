vec4 pixel(vec2 p) {
    p /= resolution;
    vec2 q = p;
    p -= .5;
    p.x *= resolution.x / resolution.y;

    p.y += tan(p.x * 1.9) * mod(-time, 5.);

    p.x += sin(p.y * 20. + time * 44. + sin(time + p.y * 20. + cos(p.y * 7. + time *15. + p.x * 20.)));

    float r = length(p) - .5;

    return texture(channel0, q) * vec4(r, r*.5 * p.x * .05, p.x * 0.7, 0.) * .1;
}
