shader_type canvas_item;

// classic floyd steinberg
// source: https://www.shadertoy.com/view/4sjGRD

const float lookupSize = 64.0;
uniform float u_error_carry;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float u_red_amount;
uniform float u_blue_amount;
uniform float u_green_amount;

// Test picture free for use CC0 Licence
// https://free-images.com/display/artistic_conception_green_689793.html

float getGrayscale(vec2 coords, vec2 iResolution){
	vec2 uv = coords / iResolution.xy;
	//uv.y = 1.0-uv.y;
	vec3 sourcePixel = texture(screen_texture, uv).rgb;
	return length(sourcePixel*vec3(0.2126,0.7152,0.0722));
}

	
void fragment() {
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	int topGapY = int(iResolution.y - FRAGCOORD.y);
	
	int cornerGapX = int((FRAGCOORD.x < 10.0) ? FRAGCOORD.x : iResolution.x - FRAGCOORD.x);
	int cornerGapY = int((FRAGCOORD.y < 10.0) ? FRAGCOORD.y : iResolution.y - FRAGCOORD.y);
	int cornerThreshhold = ((cornerGapX == 0) || (topGapY == 0)) ? 5 : 4;
	// Place fragment code here.
		if (cornerGapX+cornerGapY < cornerThreshhold) {
				
		COLOR = vec4(0,0,0,1);
		
	} else if (topGapY < 20) {
			
			if (topGapY == 19) {
				
				COLOR = vec4(0,0,0,1);
				
			} else {
		
				COLOR = vec4(1,1,1,1);
				
			}
		
	}
	else {
		
		float xError = 0.0;
		for(float xLook=0.0; xLook<lookupSize; xLook++){
			float grayscale = getGrayscale(FRAGCOORD.xy + vec2(-lookupSize+xLook,0),iResolution);
			grayscale += xError;
			float bit = grayscale >= 0.5 ? 1.0 : 0.0;
			xError = (grayscale - bit)*u_error_carry;
		}
		
		float yError = 0.0;
		for(float yLook=0.0; yLook<lookupSize; yLook++){
			float grayscale = getGrayscale(FRAGCOORD.xy + vec2(0,-lookupSize+yLook),iResolution);
			grayscale += yError;
			float bit = grayscale >= 0.5 ? 1.0 : 0.0;
			yError = (grayscale - bit)*u_error_carry;
		}
		
		float finalGrayscale = getGrayscale(FRAGCOORD.xy,iResolution);
		finalGrayscale += xError*0.5 + yError*0.5;
		float finalBit = finalGrayscale >= 0.5 ? 1.0 : 0.0;
		
		COLOR = vec4(finalBit * u_red_amount,finalBit * u_green_amount,finalBit * u_blue_amount,1);
	}	
}