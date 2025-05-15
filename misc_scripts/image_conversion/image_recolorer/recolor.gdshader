shader_type canvas_item;

uniform vec4 color_to_replace : source_color;
uniform vec4 replacement_color : source_color;
//uniform float color_threshold : hint_range(0.0, 1.0) = 0.01; // Add a threshold
const float color_threshold = 0.01;
void fragment() {
    vec4 current_color = texture(TEXTURE, UV);

    // Use a threshold to compare colors
    float color_distance = distance(current_color.rgb, color_to_replace.rgb);
    if (color_distance < color_threshold && current_color.a > 0.0) {
        COLOR = replacement_color;
    } else {
        COLOR = current_color;
    }
}
