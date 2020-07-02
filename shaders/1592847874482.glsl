float hash(vec3 p) {
    return fract(1000. * sin(p.x * 14. + p.y * .01 + p.z * .1) * (0.1 + abs(sin(p.y * 16. + p.x * 24. + p.z * 0.5))));
}

float noise(vec3 p) {
    vec3 e = vec3(0., 0., 1.);
    
    vec3 topLeft = floor(p);
    vec3 topRight = topLeft + e.zxx;
    vec3 bottomLeft = topLeft + e.xzx;
    vec3 bottomRight = topLeft + e.zzx; 

    vec3 depthTopLeft = topLeft + e;
    vec3 depthTopRight = topRight + e;
    vec3 depthBottomLeft = bottomLeft + e;
    vec3 depthBottomRight = bottomRight + e; 
    
    vec3 f = fract(p);
    
    float topLerp = mix(hash(topLeft), hash(topRight), f.x);
    float bottomLerp = mix(hash(bottomLeft), hash(bottomRight), f.x);
    float fullLerp = mix(topLerp, bottomLerp, f.y);
    
    float depthTopLerp = mix(hash(depthTopLeft), hash(depthTopRight), f.x);
    float depthBottomLerp = mix(hash(depthBottomLeft), hash(depthBottomRight), f.x);
    float depthFullLerp = mix(depthTopLerp, depthBottomLerp, f.y);
    
    return mix(fullLerp, depthFullLerp, f.z); 
}

mat2 rotate(float a) {
    a *= acos(-1.);
    return mat2(-sin(a), cos(a),
                 cos(a), sin(a));
}

float map(vec3 p) {         



    float wave = p.y;
    wave += noise(p * .2 + time * 0.8) * 4.;
    wave += noise(p + time * 1.);
    wave += noise(p * 5. + time * 5.) * .15;
    wave += noise(p * 8. + time * 3.) * .07;    
    wave += noise(p * 18. + time * 3.) * .1;    
    
    return wave;
}

vec4 pixel(vec2 p) {
    p /= resolution;
    vec2 q = p;
    p -= .5;
    p.x *= resolution.x / resolution.y;

    vec3 cam = vec3(0., 0., 2.);
    // vec3 cam = vec3(0., mod(time * 5., 6.), 2.);
    vec3 ray = vec3(p, -1.);

    // if (texture(channel1, q).g != 0.4) {
    //     return vec4(
    //         texture(channel1, q).r,
    //         texture(channel1, q - 0.0005).g,
    //         texture(channel1, q + 0.0005).b,
    //         0.
    //     );
    // }
    
    float dist = 0.;
    for (int i=0; i<150; i++) {
        vec3 p = cam + ray * dist;
        
        float tmp = map(p);
        
        if (tmp < 0.001) {
            vec3 light = vec3(-6., -6., 0.) - p;
            light = normalize(light);
            
            float shade = map(p - light);
            
            return vec4(2.2 + p.z * 0.4, 0.7 + p.y * .12, 0.4, 0.) * shade;
        }
                
        dist += tmp;
        
        if (dist > 55.) {
            break;
        }
    }

    q.y *= 1.01;
    q.y += sin(p.x * 2.5) * .014;
    q.y -= sin(p.x * 0.15 + 0.03) * .19;
    q.y -= 0.00115;
    q.x += noise(vec3(p * 10., time * 200.)) * .0199;
    q.x += noise(vec3(p * 20., time * 5.)) * .005;
    q.x -= 0.0105;
    q.y *= 1.0015;
    q.y -= 0.0006;
    return texture(channel0, q) * vec4(.995, 1.012, 1.02, 0.);
    
    return 0.12 + vec4(p.y * 0.2, p.y * 0.1 + abs(p.x) * .27, p.y + 0.08, 0.);
}
