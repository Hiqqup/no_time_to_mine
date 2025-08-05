shader_type canvas_item;


uniform highp float spin_speed = 1;
uniform highp vec2 offset = vec2(0., 0.);
uniform highp vec4 colour_1 : source_color;
uniform highp vec4 colour_2 : source_color;
uniform highp vec4 colour_3 : source_color;
uniform highp float contrast = 2.;
uniform highp float lighting = 0.4;
uniform highp float pixel_filter = 700.;


vec4 effect(vec2 screenSize, vec2 screen_coords){
	//Convert to UV coords (0-1) and floor for pixel effect
	highp float pixel_size = length(screenSize.xy) / pixel_filter;
    highp vec2 uv = (floor(screen_coords.xy*(1./pixel_size))*pixel_size - 0.5*screenSize.xy)/length(screenSize.xy) - offset;
    highp float uv_len = length(uv);

	uv=  vec2(uv.x, uv.y);
	 highp float speed =  300.0;

	//Now add the paint effect to the swirled UV
    uv *= 30.;
    speed = TIME*(spin_speed);
	highp vec2 uv2 = vec2(uv.x+uv.y);
	

	for(int i=0; i < 5; i++) {
		uv2 += sin(max(uv.x, uv.y)) + uv;
		uv  += 0.4*vec2(cos(5.1123314 + 0.353*uv2.y + speed*0.131121),sin(uv2.x - 0.113*speed));
		uv  -= .2*cos(uv.x + uv.y) - .5*sin(uv.x*0.711 - uv.y);
	}

	//Make the paint amount range from 0 - 2
    highp float contrast_mod = (0.25*contrast + 0.5 + 1.2);
	highp float paint_res = abs(.15* (uv.x +uv.y));
    highp float c1p = max(0.,1. - .4* contrast_mod*abs(1.-paint_res + .8));
    highp float c2p = max(0.,1. - .5*contrast_mod*abs(paint_res));
    highp float c3p = 1. - min(1., c1p + c2p);

	highp float ligth = (lighting - 0.2) * max(c1p*5. - 4., 0.) + lighting * max(c2p*5. - 4., 0.);
	ligth*= .2*sin(TIME) +1. ;
	highp vec4 ret_col = (0.3/contrast)*colour_1 + (1. - 0.3/contrast)*(colour_1*c1p + colour_2*c2p + vec4(c3p*colour_3.rgb, c3p*colour_1.a)) + ligth;
	ret_col  = vec4(ret_col.rgb ,1);
	return ret_col;
}



void fragment() {
	COLOR *= effect(TEXTURE_PIXEL_SIZE, UV);
}
