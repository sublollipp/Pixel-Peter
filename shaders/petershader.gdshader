shader_type canvas_item;

uniform float charge = 0.0;
uniform float pulse_speed = 10.0;
uniform bool invincible = false;
uniform float amplitude = 3.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);

	float pulse_factor = (cos(TIME * pulse_speed) * amplitude + amplitude) / (amplitude * 4.0);

	if (input_color == vec4(1.0, 1.0, 1.0, 1.0)) {
		input_color = vec4(input_color.r, 1.0 * (1.0 - charge), 1.0 * (1.0 - charge), input_color.a);
	}

	if (invincible) {
		input_color.rgb = mix(input_color.rgb, vec3(1.0, 1.0, 1.0),pulse_factor);
	}

	COLOR = input_color;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
