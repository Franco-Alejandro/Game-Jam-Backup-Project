shader_type spatial;

//parameters
uniform vec3 base_color: source_color = vec3(0.87, 0.3, 0.2);
uniform float emissive_strength: hint_range(0.0, 30.0, 0.1) = 12.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
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
