shader_type canvas_item;

uniform float progress : hint_range(-1.0, 1.0) = 0.0;
uniform vec2 center = vec2(0.5, 0.5);
uniform float radius : hint_range(0.0, 1.0) = 0.3;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// 计算当前像素到中心的距离
    vec2 uv = UV;
    float dist = distance(uv, center);
    
    // 根据进度计算收缩程度
    float scale = 1.0;
    if (progress < 0.5) {
        // 收缩阶段 (0.0 -> 0.5)
        scale = 1.0 - progress * 2.0;
    } else {
        // 展开阶段 (0.5 -> 1.0)
        scale = (progress - 0.5) * 2.0;
    }
    
    // 应用变形
    //vec2 dir = normalize(uv - center);
    vec2 new_uv = center + (uv - center) * mix(1.0, scale, smoothstep(0.0, radius, dist));
    
    COLOR = texture(TEXTURE, new_uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
