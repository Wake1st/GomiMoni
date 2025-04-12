shader_type spatial;

uniform vec4 background_color : source_color;
uniform vec4 foreground_color : source_color;
instance uniform float weight : hint_range(0.0, 1.0, 0.05) = 0.5;

void fragment() {
	if (UV.x < weight) {
		ALBEDO = foreground_color.rgb;
	} else {
		ALBEDO = background_color.rgb;
	}
}
