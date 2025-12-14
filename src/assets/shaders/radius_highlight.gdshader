shader_type canvas_item;

uniform float ring_radius : hint_range(0.1, 0.5, 0.01) = 0.4;
uniform float thickness_scalar : hint_range(0.0, 0.99, 0.05) = 0.7;
uniform float color_speed : hint_range(0.0, 50.0, 0.1) = 1.0;
uniform float aa_size : hint_range(0.001, 0.05, 0.001) = 0.005;
uniform vec4 main_color : source_color = vec4(1.0,1.0,1.0,1.0);
uniform vec4 lerp_color : source_color = vec4(1.0,1.0,1.0,1.0);

float range_lerp(float value, float min1, float min2, float max1, float max2){
	return min2 + (max2 - min2) * ((value - min1) / (max1 - min1));
}

void fragment() {
	// Calculate the distance between the current pixel and the center of the unit
	float dist = distance(UV, vec2(0.5, 0.5));
	
	// Keep the smooth inner fade from smoothstep
	float inner_fade = smoothstep(ring_radius * (1.0 - thickness_scalar), ring_radius, dist);
	
	// Apply anti-aliasing only to the outer edge
	float outer_edge = smoothstep(ring_radius - aa_size, ring_radius + aa_size, dist);
	
	// Combine: keep inner smooth fade, add outer anti-aliasing
	float alpha = (1.0 - outer_edge) * inner_fade;
	
	// Create color oscillation without affecting size
	float color_osc = cos(TIME * color_speed);
	float w = range_lerp(color_osc, -1.0, 1.0, 1.0, 0.0);
	
	// Output the final color with anti-aliased outer edge
	COLOR = vec4(mix(main_color.rgb, lerp_color.rgb, w), alpha);
}