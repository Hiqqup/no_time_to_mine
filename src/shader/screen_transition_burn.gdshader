shader_type canvas_item;

uniform float radius: hint_range(0.0, 1.0);
uniform float borderWidth = 0.02;
uniform float burnMult = 0.135;
uniform sampler2D noiseTexture;
uniform vec4 defaultColor : source_color;
uniform vec4 burnColor : source_color;



void fragment() {
	float dist = length(vec2(0.5,0.5) - UV) + (texture(noiseTexture, UV).b) * burnMult;
	COLOR.rgb = mix(defaultColor.rgb, burnColor.rgb, float(dist>radius-borderWidth));
	COLOR.a *= (float(dist<radius)) * clamp(radius+0.5, 0.5, 1.0);
}
