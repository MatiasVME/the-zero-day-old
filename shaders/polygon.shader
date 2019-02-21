shader_type canvas_item;

uniform vec2 iMouse;

vec3 distCol (float d)
{
    float a = pow(cos(d * 120.) * .5 + .5, 10.)*.8 + .2;
    vec3 c = mix(vec3(.8,.5,0.), vec3(.3,.3,.9), sign(d)*.5 + .5)*a;
    c = mix(c, vec3(.8,.8,1.), 1./(abs(d)*100.+1.));
    return c;
}

float npolySDF (float r, float n, float t, vec2 p)
{
    n *= .5;
    float o = 1.5707963/n;
    float a = atan(p.y/p.x);
    if (p.x < 0.) a += 3.1415926;
    float s = round((a + t)/3.1415926*n)/n*3.1415926 - t;
    float d = round((a + o + t)/3.1415926*n)/n*3.1415926 - o - t;
    vec2 c = vec2(cos(d),sin(d))*r;
    vec2 f = vec2(cos(s),sin(s));
    float b = length(p-c);
    float l = dot(p, f);
    l -= cos(o)*r;
    float m = b;
    if (abs(dot(vec2(p.x,-p.y), f.yx)) <= sin(o)*r) m = l;
    return m;
}

float map (vec2 p, float iTime)
{
    float t = fract(iTime/20.)*20.;
    float t2 = fract(iTime/20.)*20.;
    float a = npolySDF(.3, ceil(t/4. + 1.), iTime/8., p);
    float b = npolySDF(.3, ceil(t2/4. + 2.), iTime/8., p);
    float d = mix(a,b, smoothstep(.4,.6,fract(iTime/4.)))
     + sin(iTime*2.)*.05 - .05;
    return d;
}

vec2 normal (vec2 p, float time)
{
    return normalize(vec2(
        map(vec2(p.x + .001,p.y), time) - map(vec2(p.x - .001,p.y), time),
        map(vec2(p.x,p.y + .001), time) - map(vec2(p.x,p.y - .001), time)
        ));
}

void fragment()
{
	vec4 fragCoord = FRAGCOORD;
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	
    vec2 uv = (fragCoord.xy - .5*iResolution.xy)/iResolution.y;
    vec2 m = (iMouse.xy - .5*iResolution.xy)/iResolution.y;
    
    float b = abs(length(uv-m) - abs(map(m, TIME)));
    float n = abs(dot(uv-m, normal(m, TIME).yx*vec2(-1,1)));
    n = max(n, dot(uv-m, normal(m, TIME)));
    b = min(b, n);
    
    vec3 c = distCol(map(uv, TIME));
    c = mix(c, vec3(.9,.5,.1), smoothstep(.008,.002, b));
    COLOR = vec4(c,1);
}