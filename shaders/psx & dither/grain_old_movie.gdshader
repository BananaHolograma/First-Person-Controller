shader_type canvas_item;

uniform float u_grain_amount;
uniform float u_grain_movement;
uniform bool u_disabled;

void fragment() {
	
	// Screen Color
    vec4 screen = texture(TEXTURE, SCREEN_UV);
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = FRAGCOORD.xy / iResolution.xy;
    
	// Random noise
    float x = (uv.x + 4.0 ) * (uv.y + 4.0 ) * (TIME * u_grain_movement);
	// Add grain to Screen
	screen = screen+vec4(mod((mod(x, 13.0) ) * (mod(x, 123.0) ), 0.01)-0.005) * u_grain_amount;
    
    screen = 1.0 - screen;
	COLOR = u_disabled ? COLOR : screen;
}