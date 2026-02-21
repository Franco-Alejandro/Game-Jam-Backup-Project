shader_type spatial;

varying vec3 world_position;
varying vec3 pivot_position;

//parameters
uniform vec3 base_color_bottom: source_color = vec3(0.1, 0.1, 0.1);
uniform vec3 base_color_top : source_color = vec3(0.9, 0.9, 0.9);
uniform float mesh_height_scale = float(1.0);
uniform float mesh_height_offset = float(0.0);

//custom lerp function
vec3 lerp(vec3 color1, vec3 color2, float mask) {
	vec3 output_color = color1 + (color2 - color1) * mask;
	return output_color;
}

float lerp(float a, float b, float mask){
	float output_value = a + (b - a) * mask;
	return output_value;
}

float frac(float x){
	return x - floor(x);
}

float saturate(float x){
	return max(min(x, 1.0), 0.0);
}

void vertex() {
	// Called for every vertex the material is visible on.
	pivot_position = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	 world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	// Called for every pixel the material is visible on.
	float worldHeight = (world_position - pivot_position).y + (mesh_height_scale * 0.5);
	worldHeight = saturate(worldHeight);
	ALBEDO = lerp(base_color_bottom, base_color_top, worldHeight * worldHeight);
	//METALLIC = 1.0;
	ROUGHNESS = 0.9;
	ALPHA = 1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
