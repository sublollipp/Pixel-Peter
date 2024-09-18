shader_type canvas_item;

uniform float charge = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	if (input_color == vec4(1.0, 1.0, 1.0, 1.0)) {
		COLOR = vec4(input_color.r, 1.0 * (1.0 - charge), 1.0 * (1.0 - charge), input_color.a);
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
