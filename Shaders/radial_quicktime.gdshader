shader_type canvas_item;

// RADIAL PROGRESSBAR BY PENGGRIN
#define TWO_PI 6.28318530718

uniform vec3 primary_color: source_color = vec3(0.0, 1.0, 0.0); 
uniform vec3 outline_color: source_color = vec3(0.0);
uniform vec3 unfilled_color: source_color = vec3(0.2, 0.2, 0.2); 
uniform vec3 needle_color: source_color = vec3(1.0, 1.0, 1.0); // White needle

uniform float arc_start: hint_range(0.0, 1.0, 0.01) = 0.2;
uniform float arc_length: hint_range(0.0, 1.0, 0.01) = 0.15;
uniform float needle_position: hint_range(0.0, 1.0) = 0.0; // The moving needle line

uniform float smooth_ = 0.005;
uniform float width_in = 0.85;
uniform float width_out = 0.95;
uniform float border_width = 0.03;

vec4 radial_arc(vec2 UV_, float START, float LENGTH, float SMOOTH, float IR, float OR)
{
	vec2 uv = (UV_ * 2.0) - 1.0;
	float d = length(uv);
	float ring = smoothstep(OR + SMOOTH, OR - SMOOTH, d) - smoothstep(IR + SMOOTH, IR - SMOOTH, d);
	
	float a = atan(uv.x, -uv.y);  
	float theta = (a < 0.0) ? (a + TWO_PI) / TWO_PI : a / TWO_PI;
	
	float END = START + LENGTH;
	float bar = 0.0;
	
	if (END <= 1.0) {
		bar = step(START, theta) * step(theta, END);
	} else {
		bar = step(START, theta) + step(theta, END - 1.0);
	}
	
	return vec4(ring * bar);
}

void fragment()
{
	// 1. Draw outline and background ring
	vec4 outline = vec4(outline_color, 1.0) * radial_arc(UV, 0.0, 1.0, smooth_, width_in - border_width, width_out + border_width);
	vec4 unfilled = vec4(unfilled_color, 1.0) * radial_arc(UV, 0.0, 1.0, smooth_, width_in, width_out);
	
	// 2. Draw target zone arc segment
	vec4 primary = vec4(primary_color, 1.0) * radial_arc(UV, arc_start, arc_length, smooth_, width_in, width_out);

	if (primary.a > 0.0) {
		unfilled = vec4(0.0);
	}

	vec4 base_ring = primary + (unfilled + outline);

	// 3. Draw a thin needle line overlay (slightly wider radially so it stands out)
	vec4 needle_line = vec4(needle_color, 1.0) * radial_arc(UV, needle_position - 0.005, 0.01, smooth_, width_in - 0.03, width_out + 0.03);

	// Mix them linearly using the needle's alpha channel instead of returning early
	COLOR = mix(base_ring, needle_line, needle_line.a);
}
