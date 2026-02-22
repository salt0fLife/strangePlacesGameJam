shader_type canvas_item;
uniform sampler2D noise_1 : repeat_enable, filter_linear;
uniform vec3 color_1 : source_color;
uniform vec3 color_2 : source_color;
uniform float speed = 1.0;

float gradient(vec2 uv) {
	vec2 dif = vec2((0.5 - uv.x),(0.5-uv.y));
	return (dif.x*dif.x + dif.y*dif.y);
}

void vertex() {
	
}

void fragment() {
	
	COLOR.rgb = color_1;
	float n_1 = (texture(noise_1,UV+vec2(TIME*0.1*speed+sin(UV.y),0.0)).r + texture(noise_1,UV+vec2(TIME*0.01*speed+sin(UV.x)*0.2,TIME*0.2*speed+sin(UV.y*0.1)*0.5)).g+texture(noise_1,UV+vec2(-TIME*0.1*speed+sin(UV.x*PI),-TIME*0.05*speed)).b)*0.3333 - gradient(UV)*0.2;
	COLOR.rgb = mix(COLOR.rgb,color_2,n_1);
	if (n_1 > 0.5) {
		COLOR.rgb = mix(color_2,color_1,n_1);
	}
	//COLOR.r += gradient(UV);
	//COLOR.g -= gradient(UV)*0.3;
}

