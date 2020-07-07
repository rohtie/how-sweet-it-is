vec4 pixel(vec2 p) {
    p /= resolution;
    vec2 q = p;
    p -= .5;
    p.x *= resolution.x / resolution.y;

    float trans = (time - 20.2) * .5;

    return mix(texture(channel1, q), texture(channel2, q), trans);
}
