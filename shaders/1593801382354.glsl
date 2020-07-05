mat2 rotate(float a) {
    a *= acos(-1.);

    return mat2(-sin(a), cos(a),
                 cos(a), sin(a));
}

float smin(float a, float b, float k) {
    float ka = exp2(-k * a);
    float kb = exp2(-k * b);

    return -log2(ka + kb) / k;
}

float smax(float a, float b, float k) {
    float ka = exp2(k * a);
    float kb = exp2(k * b);

    return log2(ka + kb) / k;
}

float hashie(vec2 p) {
    return sin(p.x * 05. + sin(p.y * 200.) * 100. + p.x * p.y * 1000.);
}
       
vec2 circleRepeat(vec2 p, float reps) {
    float angle = 2. * acos(-1.) / reps;
    
    float a = atan(p.y, p.x) + angle * .5;
    float r = length(p);
    float c = floor(a / angle);
    
    a = mod(a, angle) - angle * .5;
    p = vec2(cos(a), sin(a)) * r;
    
    return p;
}


vec4 side(vec2 p) {
    return vec4(smoothstep(0., 0.05, mod(p.x, 0.1) - .04));
}

vec4 top(vec2 p) {
    return vec4(smoothstep(0., 0.05, mod(p.x, 0.1) - .04));
}

vec4 bottom(vec2 p) {
    return vec4(smoothstep(0., 0.05, mod(p.x, 0.1) - .04));
}


vec4 reflectionmap(vec3 dir) {
    vec2 p = vec2(dir.x, dir.y);
    return vec4(smoothstep(0., 0.05, mod(p.x, 0.1) - .04));



    vec3 aDir = abs(dir);

    bool isXPositive = dir.x > 0.;
    bool isYPositive = dir.y > 0.;
    bool isZPositive = dir.z > 0.;

    vec2 coords = vec2(0.);
    
    // +X
    if (isXPositive && aDir.x >= aDir.y && aDir.x >= aDir.z) {
        coords = vec2(-dir.z, dir.y);
        return side(coords);
    }
    
    // -X
    if (!isXPositive && aDir.x >= aDir.y && aDir.x >= aDir.z) {
        coords = vec2(dir.z, dir.y);
        return side(coords);        
    }

    // +Y
    if (isYPositive && aDir.y >= aDir.x && aDir.y >= aDir.z) {
        coords = vec2(dir.x, -dir.z);
        return top(coords);
    }
    
    // -Y
    if (!isYPositive && aDir.y >= aDir.x && aDir.y >= aDir.z) {
        coords = vec2(dir.x, dir.z);
        return bottom(coords);        
    }

    // +Z
    if (isZPositive && aDir.z >= aDir.x && aDir.z >= aDir.y) {
        coords = vec2(dir.x, dir.y);
        return side(coords);        
    }
    
    // -Z
    if (!isZPositive && aDir.z >= aDir.x && aDir.z >= aDir.y) {
        coords = vec2(-dir.x, dir.y);
        return side(coords);        
    }

    return vec4(1., 0., 0., 0.);
}


float water(vec3 p) {
    float r = 1.;

    float waterMask = max(-p.y - 1., length(p - vec3(0., -1., 0.)) - .65);

    r = min(r, max(-p.y + 0.25, length(p * vec3(1., 2., 1.) - vec3(0., 0.2, 0.)) - .53 - sin(p.y * 20. + time * 2.) * .06));

    float cylinder = length(max(abs(p) - vec3(0., 20., 0.), 0.)) - 1.01 - sin(p.y * 4.6 + time * 18.) * .005;
    cylinder = max(-cylinder, cylinder - 0.015);

    float mask = 1.;
    
    p.xz *= rotate(0.25);
    mask = min(mask, abs(p.x) - .175);
    
    p.xz *= rotate(0.2);
    mask = min(mask, abs(p.x) - .08);

    p.xz *= rotate(0.8);
    mask = min(mask, abs(p.x) - .28);    


    cylinder = max(cylinder, mask);

    r = min(r, max(cylinder, abs(p.y + 0.6) - .6));

    float waves = sin(length(p) * 2. - time * (7. - length(p) * .03));

    p.y += waves * 0.01;

    r = smin(r, max(p.y, length(p * vec3(1., 4., 1.)) - .99), 30.);
    
    p.y += 1. + waves * 0.05;
    r = smin(r, max(abs(p.y) - 0.05, length(p) - 5.), 20.);    

    r = smax(r, -waterMask, 20.);

    return r;
}

float stars(vec3 p) {
    p.xz *= rotate(-time * .1);

    p.y -= 0.3;

    float r = length(vec2(length(p.xz) - 0.5 - sin(atan(p.x, p.z) * 4.) * 0.05, p.y)) - 0.007;    

    p.xz = circleRepeat(p.xz, 4.);    
    p.x -= 0.535;

    p.xz *= rotate(0.0);
    p.xy *= rotate(0.4);
    p.zy *= rotate(0.4);

    return min(r, max(abs(p.z) - .01, length(p) - .125 - sin(atan(p.x, p.y) * 5.) * .018));    
}

float fountain(vec3 p) {
    p.y *= 2.;

    float r = max(p.y, max(length(p) - 1., -(length(p) - .99)) - sin(p.y * 20. + time * 5.) * .005);

    p.y += 0.05;
    r = min(r, max(-p.y - 1.05, length(p - vec3(0., -1., 0.)) - .2));

    p.y += 1.4;
    r = min(r, length(max(abs(p) - vec3(0.0, .3, 0.0), 0.)) - 0.18 + p.y * .12 - sin(p.y * 25. + time * 1.1) * .0075 - sin(atan(p.x, p.z) * 15.) * .02);

    p.y -= 0.75;
    r = min(r, max(-p.y - 1.3, length(p - vec3(0., -1.95, 0.)) - 0.9 - sin(time * 1.5 + p.y * 25.) * 0.02 - sin(atan(p.x, p.z) * 25.) * .02));

    p.y -= 1.2;

    p.xz *= rotate(-time * .1);

    r = min(r, max(p.y, max(-max(abs(p.y + 0.65) - 0.45, min(abs(p.x) - .05, abs(p.z) - .05)), length(p) - .5)));
    r = min(r, max(abs(p.y - 0.11) - 0.1, max(-max(abs(p.y - 0.45) - 0.45, min(abs(p.x) - .3, abs(p.z) - .3)), length(p) - .55 - p.y * .7)));

    return r * .4;
}

float map(vec3 p) {
    return min(stars(p), min(water(p), fountain(p)));
}

vec3 getNormal( vec3 p ) {
    vec2 k = vec2(1, -1);
    vec2 kek = k * 0.0001;
    return normalize( k.xyy*map( p + kek.xyy ) + 
                      k.yyx*map( p + kek.yyx ) + 
                      k.yxy*map( p + kek.yxy ) + 
                      k.xxx*map( p + kek.xxx ) );
}

vec4 pixel(vec2 p) {
    p /= resolution;
    vec2 q = p;
    p -= .5;
    p.x *= resolution.x / resolution.y;

    vec3 cam = vec3(0., 0.5, 4.);
    vec3 ray = vec3(p, -1.);

    cam.zx *= rotate(time * .04 + 1.05);
    ray.zx *= rotate(time * .04 + 1.05);
    // cam.xy *= rotate(0.4);    
    // ray.xy *= rotate(0.4);    

    float dist = 0.;

    for (int i=0; i<100; i++) {
        vec3 p = cam + ray * dist;

        float tmp = map(p);

        if (tmp < 0.001) {
            vec3 light = normalize(p - vec3(4., -0.5, 5.));


            float shade = map(p - light);
            vec3 normal = getNormal(p);
            vec3 reflectedNormal = reflect(ray, normal);

            if (stars(p) == tmp) {
                return vec4(4.9 + p.y * 2., 4.0, 0.2, 0.) * shade * .7 + reflectedNormal.x;
            }

            if (water(p) == tmp) {
                return reflectionmap(reflectedNormal) * shade * 4. * vec4(.6 - length(p.xz) * .5, 2.9, 1.6 - length(p.xz) * .2, 0.) + 0.2;
            }

            if (fountain(p) == tmp) {
                float ring = 1. - smoothstep(0., 0.001, abs(p.y + 0.52) - 0.04);
                return vec4(shade * 2.) * vec4(p.y * .35 + 1.35 + ring * 1.25 + mod(p.y, 0.075) * 5., 0.9 + ring * 1.2 - mod(p.y + 0.31 + sin(p.x * 14. + time * 6.5) * .005, 0.075) * 5., 2.2 - ring, 0.);
            }

            return vec4(shade);
        }

        dist += tmp;
    }

    return vec4(0.);
}
