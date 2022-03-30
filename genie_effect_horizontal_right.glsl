precision mediump float;

varying vec2 v_texcoord;

uniform sampler2D u_texture_1;
uniform float u_time;

void main() {
    const float pi = 3.1415926;
    
    // 曲线函数演变的持续时间
    const float curve_animation_duration = 0.4;
    // 平移动画的持续时间
    const float translation_animation_duration = 1.0;
    
    float top_min_end = 0.2;
    float bottom_max_end = 0.1;
    
    // 曲线函数演变的进度
    float curve_animation_progress = clamp(u_time / curve_animation_duration, 0.0, 1.0);
    
    float top_min = 1.0 - curve_animation_progress * (1.0 - top_min_end);
    float bottom_max = curve_animation_progress * bottom_max_end;
    
    // 上侧曲线：A * sin(π * x + π * 0.5) + D
    // D - A = min
    // D + A = 1
    float topD = (top_min + 1.0) / 2.0;
    float topA = 1.0 - topD;
    float top = topA * sin(pi * v_texcoord.x + pi * 0.5) + topD;

    // 下侧曲线：A * sin(π * x - π * 0.5) + D
    // D - A = 0
    // D + A = max
    float bottomD = bottom_max / 2.0;
    float bottomA = bottomD;
    float bottom = bottomA * sin(pi * v_texcoord.x - pi * 0.5) + bottomD;
    
#define NO_REPEAT
#ifdef NO_REPEAT
    // 平移动画的进度（平移动画在曲线函数演变结束之后进行）
    float translation_animation_progress = clamp((u_time - curve_animation_duration) / translation_animation_duration, 0.0, 1.0);
#else
    // 平移动画的进度（平移动画在曲线函数演变结束之后进行）
    float translation_animation_progress = (u_time - curve_animation_duration) / translation_animation_duration;
    if (translation_animation_progress < 0.0) {
        translation_animation_progress = 0.0;
    }
#endif
    
    gl_FragColor = texture2D(u_texture_1, vec2(v_texcoord.x - translation_animation_progress, (v_texcoord.y - bottom) / (top - bottom)));
    if (v_texcoord.y > top || v_texcoord.y < bottom) {
        gl_FragColor = vec4(0.0);
    }
    
#ifdef NO_REPEAT
    if (v_texcoord.x < translation_animation_progress) {
        gl_FragColor = vec4(0.0);
    }
#endif
}
