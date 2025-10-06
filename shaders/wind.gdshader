shader_type canvas_item;

uniform float sway_strength = 0.2;
uniform float sway_speed = 1.0;
uniform float offset = 0.1;

void fragment() {
	// Called for every pixel the material is visible on.
}

void vertex() {
    float base_sway = sin(TIME * sway_speed + VERTEX.y * 0.05) * sway_strength + offset;
    float final_sway = base_sway;
    
    float height_factor = (1.0 - VERTEX.y) / 80.0;
    height_factor = clamp(height_factor, 0.0, 1.0);
    
    VERTEX.x += final_sway * height_factor * 15.0;
}