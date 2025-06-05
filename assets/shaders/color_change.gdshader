shader_type canvas_item;

uniform vec4 target_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float color_intensity : hint_range(0.0, 2.0) = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Replace all pixels with target color, keeping original alpha
    COLOR.rgb = target_color.rgb * color_intensity;
    COLOR.a = tex_color.a;
}