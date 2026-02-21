shader_type spatial;

//parameters
uniform vec3 water_base_color : source_color;
uniform float roughness;
uniform float metalness;
uniform float alpha;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 output_color = water_base_color;
	ALBEDO = output_color;
	METALLIC = metalness;
	ROUGHNESS = roughness;
	ALPHA = alpha;	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
