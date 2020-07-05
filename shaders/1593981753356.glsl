vec4 pixel(vec2 p) {
    p /= resolution;
    vec2 q = p;
    p -= .5;
    p.x *= resolution.x / resolution.y;


    if (time > 110.) {
        return mix(texture(channel1, q), texture(channel2, q), .99);
    }


    float fadein = (time - 73.571) * .01;

    if (length(texture(channel1, q)) < 0.37) {
        q *= .996 + sin(q.x) * .002;
        q += 0.002;
        return texture(channel2, q) * .99;
    }


    return mix(texture(channel1, q), texture(channel0, q) * .986, texture(channel0, q).r * 750.) * fadein;
}
