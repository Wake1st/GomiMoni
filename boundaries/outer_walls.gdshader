shader_type spatial;

uniform vec4 color : source_color;
uniform float amplitude : hint_range(1.0, 5.0, 0.1) = 4.0;
uniform float wave_length: hint_range(0.0, 1.0, 0.04) = 0.5;
uniform float messiness : hint_range(0.0, 3.0, 0.1) = 1.0;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void vertex() {
	// we don't want any seem breaks
	if (!(VERTEX.z > 0.0 && VERTEX.x == 0.0)) {
		float r = sqrt(VERTEX.x * VERTEX.x + VERTEX.z * VERTEX.z);
		float angle = atan(VERTEX.z, VERTEX.x);
		r += messiness * random(UV);
		VERTEX.x = r * cos(angle);
		VERTEX.z = r * sin(angle);
	}
	
	VERTEX.y = amplitude * sin(wave_length * VERTEX.y);
}

void fragment() {
	ALBEDO = color.rgb;
}
