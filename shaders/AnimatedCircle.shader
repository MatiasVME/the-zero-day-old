shader_type canvas_item;

uniform vec2 mouse = vec2(100.0, 100.0);

void fragment() {
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	float time = TIME;
	
	float ratio = resolution.x / resolution.y;
	float PI = 3.141592653589793;
	
	vec2 position = (FRAGCOORD.xy / resolution.y );
	vec2 p = vec2( position.x - ratio / 2.0, position.y - .5 );
	vec3 color = vec3(0.5, 0.6, 0.7);
	color *= smoothstep( 0.1, 0.2, distance(p, vec2( 0, 0 )) );
	color *= smoothstep( -PI, PI, cos(atan(p.y, p.x) * time));
	color *= smoothstep( -PI, PI, sin(atan(p.y, p.x)));
	COLOR = vec4(color, 1.0);
}