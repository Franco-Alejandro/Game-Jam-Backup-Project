shader_type spatial;

varying vec3 world_position;

//parameters
uniform sampler2D noise_texture;
uniform sampler2D grain_texture: filter_nearest_mipmap;
uniform vec3 base_color = vec3(0.65, 0.75, 0.9);
uniform vec3 blend_color = vec3(0.35, 0.45, 0.75);
uniform vec3 sparkle_color = vec3(0.21, 0.2, 50);
uniform float sparkle_emissive = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
	
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

//custom lerp function
vec3 lerp(vec3 color1, vec3 color2, float mask) {
	vec3 output_color = color1 + (color2 - color1) * mask;
	return output_color;
}

float lerp(float a, float b, float mask) {
	float output_value = a + (b - a) * mask;
	return output_value;
}

float saturate(float a){
	return max(min(a, 1.0), 0.0);
}

float frac(float a){
	return a - floor(a);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 texture_mask = texture(noise_texture, world_position.xz * 0.1);
	float sparkle_mask = texture(grain_texture, world_position.xz * 0.05).r;
	sparkle_mask = saturate(sparkle_mask - 0.95) * 10.0;
	
	vec3 sparkles = sparkle_mask * sparkle_color;
	sparkles *= sparkle_emissive;
	vec3 snow_color = lerp(base_color, blend_color, texture_mask.r);
	
	vec3 output_color = snow_color + sparkles;
	ALBEDO = output_color;
	//METALLIC = 1.0;
	ROUGHNESS = 0.9;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
