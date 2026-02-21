shader_type spatial;

//parameters
uniform vec3 base_color: source_color = vec3(0.87, 0.3, 0.2);
uniform float emissive_strength_max: hint_range(0.0, 30.0, 0.1) = 18.0;
uniform float emissive_strength_min: hint_range(0.0, 30.0, 0.1) = 5.0;
uniform float flickering_speed = float(10);

float blinking() {
	return ((sin(TIME * flickering_speed) * sin(TIME * flickering_speed * 0.33) * sin(TIME * flickering_speed * 0.89)) + 1.0) / 2.0;
}

//custom lerp function
vec3 lerp(vec3 color1, vec3 color2, float mask) {
	vec3 output_color = color1 + (color2 - color1) * mask;
	return output_color;
}

float lerp(float a, float b, float mask){
	float output_value = a + (b - a) * mask;
	return output_value;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float emissive_strength = lerp(emissive_strength_min, emissive_strength_max, blinking());
	vec3 output_color = base_color * emissive_strength;
	ALBEDO = vec3(0.0, 0.0, 0.0);
	//METALLIC = 1.0;
	ROUGHNESS = 0.9;
	ALPHA = 1.0;
	EMISSION = output_color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
