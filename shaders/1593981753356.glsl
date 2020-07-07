vec4 pixel(vec2 p) {
    p /= resolution;
    vec2 q = p;
    p -= .5;
    p.x *= resolution.x / resolution.y;


    if (time > 105.) {
        return mix(texture(channel1, q), texture(channel0, q), .99);
    }


    float fadein = (time - 73.571) * .01;
    // fadein = 1.;


    if (length(texture(channel1, q)) < 0.37) {
        q *= .996 + sin(q.x) * .002;
        q += 0.002;
        return texture(channel0, q) * .99;
    }

    // return mix(texture(channel1, q).brgr * 3., texture(channel1, q + vec2(0.005, 0.)).grbr, texture(channel1, q + vec2(0.01, 2.)).g * 7.6);
    // return mix(texture(channel1, q), texture(channel0, q) * .986, texture(channel0, q).r * 750.);

    // return mix(texture(channel1, q), texture(channel2, q), trans);


    // return mix(texture(channel2, q), texture(channel1, q), texture(channel2, q).r * 30.);


    // return mix(texture(channel1, q) * 2.15, texture(channel1, q).brgr + texture(channel2, q).brgr * .37, texture(channel2, q).b * 2.9);


    // return mix(texture(channel2, q), texture(channel1, q) * .95, texture(channel2, q).b * 7.) * fadein;


    // return texture(channel2, q);


    return mix(texture(channel2, q), texture(channel1, q) * .986, texture(channel1, q).r * 750.) * fadein;
}
