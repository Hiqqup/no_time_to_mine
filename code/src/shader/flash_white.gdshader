shader_type canvas_item;

uniform float flash : hint_range(0.0, 1.0, 0.1) = 0;
uniform bool show = true;

void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	COLOR = mix( vec4(1.0,1.0,1.0, pixel.a), pixel, 1.0- flash);
}
