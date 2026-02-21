shader_type spatial;

varying vec3 world_position;

//parameters
uniform vec3 base_color: source_color = vec3(0.87, 0.3, 0.2);
uniform float emissive_strength_max: hint_range(0.0, 30.0, 0.1) = 18.0;
uniform float emissive_strength_min: hint_range(0.0, 30.0, 0.1) = 5.0;
uniform float flickering_speed = float(10);

float blinking(float offset, float speed) {
	return ((sin((TIME + offset) * speed) * sin(TIME * speed * 0.33) * sin(TIME * speed * 0.89)) + 1.0) / 2.0;
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

float frac(float x){
	return x - floor(x);
}

void vertex() {
	// Called for every vertex the material is visible on.
	world_position = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
}

void fragment() {
	// Called for every pixel the material is visible on.
	float offset = (world_position.x + world_position.y);
	float random_flicker_speed = (frac(offset) * 3.0) + flickering_speed;
	float emissive_strength = lerp(emissive_strength_min, emissive_strength_max, blinking(offset, random_flicker_speed));
	vec3 output_color = base_color * emissive_strength;
	ALBEDO = vec3(0.0, 0.0, 0.0);
	//METALLIC = 1.0;
	ROUGHNESS = 0.9;
	EMISSION = output_color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
