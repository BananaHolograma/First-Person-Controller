shader_type canvas_item;

uniform float sharpen_amount :hint_range(0,4) = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

vec4 sharpenMask (sampler2D st, vec2 fc, vec2 sps){
	// Sharpen detection matrix [0,1,0],[1,-4,1],[0,1,0]
	// Colors
	vec4 up = texture (st, (fc + vec2 (0, 1))/sps);
	vec4 left = texture (st, (fc + vec2 (-1, 0))/sps);
	vec4 center = texture (st, fc/sps);
	vec4 right = texture (st, (fc + vec2 (1, 0))/sps);
	vec4 down = texture (st, (fc + vec2 (0, -1))/sps);
	
	// Return edge detection
	return (1.0 + 4.0*sharpen_amount)*center -sharpen_amount*(up + left + right + down);
}

void fragment(){
	// Detect edges and output to screen
	COLOR = sharpenMask (SCREEN_TEXTURE, FRAGCOORD.xy, 1.0 / SCREEN_PIXEL_SIZE);
}