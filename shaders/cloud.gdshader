shader_type canvas_item;

uniform sampler2D perlin_noise: repeat_enable;
uniform sampler2D cell_noise: repeat_enable;
uniform float cloud_threshold: hint_range(0.0, 1.0) = 0.5;
uniform float edge_hardness: hint_range(1.0, 20.0) = 8.0;
uniform float noise_scale = 1.0;
uniform float speed = 0.5;
uniform float strength = 0.1;

vec2 seamless_uv(vec2 uv, float scale) {
    return fract(uv * scale);
}

void fragment() {
    
    vec2 uv1 = seamless_uv(UV + TIME * vec2(0.02, 0.005) * speed, noise_scale);
    vec2 uv2 = seamless_uv(UV + TIME * vec2(0.01, -0.003) * speed, noise_scale * 1.3);
    
    // 采样噪声纹理
    float perlin = texture(perlin_noise, uv1).r;
    float cell = texture(cell_noise, uv2).r;
    
    // 混合噪声创建云基础形状
    float cloud_base = (perlin * 0.7 + cell * 0.3);
    
    // 使用阈值和硬边处理创建清晰边界
    float cloud = smoothstep(cloud_threshold - 0.3, cloud_threshold + 0.3, cloud_base);
    
    // 可选：更硬的边界（完全清晰）
     //float cloud = step(cloud_threshold, cloud_base);
    
    // 应用边缘硬度
    cloud = pow(cloud, 1.0 / edge_hardness) * strength;
    
    COLOR = vec4(vec3(1.0,0.3,0.05), cloud);
}