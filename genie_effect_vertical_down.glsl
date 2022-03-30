precision mediump float;

varying vec2 v_texcoord;

uniform sampler2D u_texture_2;
uniform float u_time;

void main() {
    const float pi = 3.1415926;
    
    // 曲线函数演变的持续时间
    const float curve_animation_duration = 0.4;
    // 平移动画的持续时间
    const float translation_animation_duration = 1.0;
    
    float left_max_end = 0.8;
    float right_min_end = 0.9;
    
    // 曲线函数演变的进度
    float curve_animation_progress = clamp(u_time / curve_animation_duration, 0.0, 1.0);
    
    float left_max = curve_animation_progress * left_max_end;
    float right_min = 1.0 - curve_animation_progress * (1.0 - right_min_end);
    
    // 左侧曲线：A * sin(π * y + π * 0.5) + D
    // D - A = 0
    // D + A = max
    float leftD = left_max / 2.0;
    float left = leftD * sin(pi * v_texcoord.y + pi * 0.5) + leftD;
    
    // 右侧曲线：A * sin(π * y - π * 0.5) + D
    // D - A = min
    // D + A = 1
    float rightD = (right_min + 1.0) / 2.0;
    float rightA = 1.0 - rightD;
    float right = rightA * sin(pi * v_texcoord.y - pi * 0.5) + rightD;
    
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
    
    gl_FragColor = texture2D(u_texture_2, vec2((v_texcoord.x - left) / (right - left), v_texcoord.y + translation_animation_progress));
    if (v_texcoord.x < left || v_texcoord.x > right) {
        gl_FragColor = vec4(0.0);
    }
    
#ifdef NO_REPEAT
    if (v_texcoord.y + translation_animation_progress > 1.0) {
        gl_FragColor = vec4(0.0);
    }
#endif
}
