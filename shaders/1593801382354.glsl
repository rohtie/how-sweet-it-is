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

float hash(vec2 p) {
    return fract(sin(1000. * p.x * p.y + 0.5) + p.x + 0.5 + sin(p.y * 15. + 0.5) * p.x * 690.);
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

    float waterMask = max(p.y + 1.07, length(p - vec3(0., -1.07, 0.)) - .99);

    float bigFountainEdge = length(vec2(length(p.xz) - 3.91, p.y + 0.95)) - 0.01;

    r = min(r, max(-p.y + 0.25, length(p * vec3(1., 1.4, 1.) - vec3(0., 0.2, 0.)) - .37 - sin(p.y * 20. + time * 2.) * .06));

    float rawCylinder = length(max(abs(p) - vec3(0., 20., 0.), 0.));
    float cylinder = max(-(rawCylinder - 1.01), rawCylinder - 1.01 - 0.015 - sin(p.y * 4.6 + time * 18.) * .008);
    float outerCylinder = max(-(rawCylinder - 3.98), rawCylinder - 3.98 - 0.01 - sin(p.y * 4.6 + time * 18.) * .008);

    float mask = 1.;
    
    p.xz *= rotate(0.25);
    mask = min(mask, abs(p.x) - .175);
    
    p.xz *= rotate(0.2);
    mask = min(mask, abs(p.x) - .08);

    p.xz *= rotate(0.8);
    mask = min(mask, abs(p.x) - .28);


    cylinder = max(cylinder, mask);

    p.xz *= rotate(0.7);
    mask = min(mask, abs(p.x) - .38);

    p.xz *= rotate(0.23);
    mask = min(mask, abs(p.x) - .03);    

    outerCylinder = max(p.y + .95, max(outerCylinder, mask));


    r = min(r, max(cylinder, abs(p.y + 0.6) - .6));

    float waves = exp(-length(p)) * cos(2.5 * length(p) * acos(-1.) - time * 4.) * 8.;

    p.y += waves * 0.01;

    r = smin(r, max(p.y, length(p * vec3(1., 4., 1.)) - .99), 30.);

    waves -= smoothstep(1.2, 0.0, length(p.xz)) * -20.;    
    p.y += 1. + waves * 0.05;
    r = smin(r, max(abs(p.y - 0.07) - 0.00, length(p) - 3.9), 20.);    

    r = smin(r, waterMask, 10.);
    r = smin(r, bigFountainEdge, 25.);

    r = smin(r, outerCylinder, 30.);

    return r * .99;
}

float stars(vec3 p) {
    p.xz *= rotate(-time * .1);

    p.y -= 0.3;

    float r = length(vec2(length(p.xz) - 0.4 - sin(atan(p.x, p.z) * 4.) * 0.05, p.y)) - 0.007;    

    p.xz = circleRepeat(p.xz, 4.);    
    p.x -= 0.435;

    p.xz *= rotate(0.0);
    p.xy *= rotate(0.4);
    p.zy *= rotate(0.4);

    return min(r, max(abs(p.z) - .01, length(p) - .105 - sin(atan(p.x, p.y) * 5.) * .018));    
}

float fountain(vec3 p) {
    float fountainHoles = 1.;
    {
        vec3 p = p;
        p.y += 0.25;
        p.y *= .7;
        p.xz = circleRepeat(p.xz, 35.);
        p.xz *= rotate(1. / 35.);
        p.xz += 0.5;
        fountainHoles = min(fountainHoles, length(max(abs(p - vec3(0., -0.75, 0.)) - vec3(0., 0., 20.), 0.)) - .15);
    }

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

    r = min(r, max(p.y, max(-max(abs(p.y + 0.65) - 0.45, min(abs(p.x) - .05, abs(p.z) - .05)), length(p) - .4)));
    r = min(r, max(abs(p.y - 0.08) - 0.07, max(-max(abs(p.y - 0.45) - 0.45, min(abs(p.x) - .25, abs(p.z) - .25)), length(p) - .45 - p.y * .7)));

    p.y += 2.35;
    float rawCylinder = length(max(abs(p) - vec3(0., 30., 0.), 0.));
    float cylinder = max(abs(p.y + 0.15) - .13, max(-(rawCylinder - 3.75), rawCylinder - 3.95));

    cylinder = min(cylinder, max(abs(p.y + 0.9) - .6, rawCylinder - 3.8));
    cylinder = min(cylinder, max(abs(p.y + 1.1) - .2, rawCylinder - 3.95));

    cylinder = max(cylinder, -fountainHoles);

    r = min(r, cylinder);

    p.y += .89;
    r = min(r, max(p.y, max(length(p) - 3.95, -(length(p) - 3.95))));

    return r * .8;
}

float map(vec3 p) {
    return min(stars(p), min(water(p), fountain(p)));
}

vec3 getNormal( vec3 p ) {
    vec2 k = vec2(1, -1);
    vec2 kek = k * 0.0001;
    return normalize(k.xyy*map(p + kek.xyy) + 
                     k.yyx*map(p + kek.yyx) + 
                     k.yxy*map(p + kek.yxy) + 
                     k.xxx*map(p + kek.xxx));
}

vec4 pixel(vec2 p) {
    p /= resolution;
    vec2 q = p;
    p -= .5;
    p.x *= resolution.x / resolution.y;

    vec3 cam = vec3(0., -0.66 - max(0., (time - 95.)) * .5, 1.5 + (time - 75.) * .3);
    vec3 ray = vec3(p, -1.);

    cam.zy *= rotate(.4 + (time - 75.) * 0.0025);
    ray.zy *= rotate(.4 + (time - 75.) * 0.0025);

    cam.zx *= rotate(time * .0 - 1.34);
    ray.zx *= rotate(time * .0 - 1.34);

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
                return reflectionmap(reflectedNormal) * shade * 4. * vec4(.6 - length(p.xz) * 5.95, 4.15, 1.6 - length(p.xz) * .1, 0.) + 0.2;
            }

            if (fountain(p) == tmp) {
                float ring = 1. - smoothstep(0., 0.001, abs(p.y + 0.52) - 0.04);
                return vec4(shade * 1.2) * vec4(p.y * .35 + 1.35 + ring * 1.25 + mod(p.y, 0.075) * 5., 0.9 + ring * 1.2 - mod(p.y + 0.31 + sin(p.x * 14. + time * 6.5) * .005, 0.075) * 5., 2.2 - ring, 0.);
            }

            return vec4(shade);
        }

        if (dist > 50.) {
            break;
        }

        dist += tmp;
    }

    p.y += sin(p.x * 5. + time * 2.) * .05;
    p.x += sin(p.y * 2.);
    float r = length(p) - .4;

    return vec4(1. - smoothstep(0., 0.0002, hash(q + time * .00000005))) + vec4(r * 1.4 - p.y * .2, r + p.y * .5, r + abs(p.x) * 0.75, 0.);
}
