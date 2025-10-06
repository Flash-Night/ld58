shader_type canvas_item;

// 墨水颜色
uniform vec4 ink_color : source_color = vec4(0.1, 0.1, 0.3, 1.0);
// 晕染强度
uniform float bleed_intensity : hint_range(0.0, 1.0) = 0.5;
// 晕染速度
uniform float bleed_speed : hint_range(0.0, 2.0) = 1.0;
// 边缘模糊度
uniform float edge_blur : hint_range(0.0, 0.1) = 0.02;
// 噪声纹理
uniform sampler2D noise_texture;
// 时间参数
uniform float time;

// 随机函数
float rand(vec2 coord) {
    return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453);
}

// 噪声函数
float noise(vec2 coord) {
    vec2 i = floor(coord);
    vec2 f = fract(coord);
    
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// 分形布朗运动
float fbm(vec2 coord) {
    float value = 0.0;
    float amplitude = 0.5;
    
    for (int i = 0; i < 4; i++) {
        value += amplitude * noise(coord);
        coord *= 2.0;
        amplitude *= 0.5;
    }
    
    return value;
}

void fragment() {
    // 获取原始颜色
    vec4 original_color = texture(TEXTURE, UV);
    
    // 如果原始像素是透明的，不进行处理
    if (original_color.a == 0.0) {
        COLOR = original_color;
    }else{
    
	    // 计算晕染偏移
	    vec2 bleed_uv = UV;
	    
	    // 添加时间动画
	    float time_factor = time * bleed_speed;
	    
	    // 计算多重噪声偏移
	    vec2 offset1 = vec2(
	        fbm(UV * 3.0 + time_factor * 0.5) - 0.5,
	        fbm(UV * 3.0 + 1.0 + time_factor * 0.5) - 0.5
	    ) * bleed_intensity * 0.02;
	    
	    vec2 offset2 = vec2(
	        fbm(UV * 8.0 + time_factor * 1.2) - 0.5,
	        fbm(UV * 8.0 + 2.0 + time_factor * 1.2) - 0.5
	    ) * bleed_intensity * 0.01;
	    
	    // 组合偏移
	    vec2 total_offset = offset1 + offset2;
	    bleed_uv += total_offset;
	    
	    // 采样周围像素创建模糊效果
	    vec4 blurred_color = vec4(0.0);
	    float samples = 0.0;
	    
	    for (float x = -1.0; x <= 1.0; x += 1.0) {
	        for (float y = -1.0; y <= 1.0; y += 1.0) {
	            vec2 sample_uv = bleed_uv + vec2(x, y) * edge_blur;
	            vec4 sample_color = texture(TEXTURE, sample_uv);
	            
	            if (sample_color.a > 0.0) {
	                blurred_color += sample_color;
	                samples += 1.0;
	            }
	        }
	    }
	    
	    if (samples > 0.0) {
	        blurred_color /= samples;
	    }
	    
	    // 计算边缘强度
	    float edge_strength = fbm(UV * 10.0 + time_factor);
	    
	    // 混合原始颜色和墨水颜色
	    vec4 final_color = mix(original_color, ink_color, bleed_intensity * 0.7);
	    
	    // 添加边缘变化
	    final_color.rgb *= (0.9 + edge_strength * 0.2);
	    
	    // 与模糊颜色混合
	    final_color = mix(final_color, blurred_color, bleed_intensity * 0.3);
	    
	    // 根据噪声调整alpha
	    float alpha_noise = fbm(UV * 15.0 + time_factor * 0.3);
	    final_color.a *= (0.8 + alpha_noise * 0.4);
	    
	    COLOR = final_color;
	}
}