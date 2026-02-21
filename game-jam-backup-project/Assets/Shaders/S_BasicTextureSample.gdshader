shader_type spatial;

//parameters
uniform sampler2D color_texture;
uniform float roughness;
uniform float metalness;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 output_color = texture(color_texture, UV).xyz;
	ALBEDO = output_color;
	METALLIC = metalness;
	ROUGHNESS = roughness;
	ALPHA = 1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
