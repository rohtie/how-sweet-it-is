vec4 pixel(vec2 p) {
    p /= resolution;
    vec2 q = p;
    p -= .5;
    p.x *= resolution.x / resolution.y;


    float fadein = (time - 73.571) * .01;

    return mix(texture(channel1, q), texture(channel0, q) * .986, texture(channel0, q).r * 750.) * fadein;
}
