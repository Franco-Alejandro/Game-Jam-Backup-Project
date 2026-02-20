shader_type spatial;

//parameters
uniform sampler2D noise_texture;
uniform sampler2D grain_texture;
uniform vec3 base_color;
uniform vec3 blend_color;
uniform vec3 sparkle_color;
uniform float sparkle_emissive;

void vertex() {
	// Called for every vertex the material is visible on.
}

//custom lerp function
vec3 lerp(vec3 color1, vec3 color2, float mask) {
	vec3 output_color = color1 + (color2 - color1) * mask;
	return output_color;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 texture_mask = texture(noise_texture, UV * 10.0);
	float sparkle_mask = texture(grain_texture, UV * 10.0).r;
	
	vec3 sparkles = step(0.94, sparkle_mask) * sparkle_color;
	sparkles *= sparkle_emissive;
	vec3 snow_color = lerp(base_color, blend_color, texture_mask.r);
	
	vec3 output_color = snow_color + sparkles;
	ALBEDO = output_color;
	METALLIC = 0.0;
	ROUGHNESS = 1.0;
	ALPHA = 1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
