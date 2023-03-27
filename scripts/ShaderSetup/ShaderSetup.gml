// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function shader_setup(_shader){
	if shader_is_compiled(_shader){
		switch(_shader){
			case shd_bcs:
				shader = shd_bcs;
				shd_bcs_setup = true;
				u_brightness = shader_get_uniform(shader, "brightness");
				u_contrast = shader_get_uniform(shader, "contrast");
				bcs_brightness = 0;
				bcs_contrast = 1;
				bcs_brightness_goal = bcs_brightness;
				bcs_contrast_goal = bcs_contrast;
			break;
		}
	}
}

function shader_is_setup(_shader){
	return var_in_self(shader_get_name(_shader) + "_setup");
}

function shader_draw_begin(_shader){
	if !var_in_self("shader") exit;
	if !shader_is_compiled(_shader) exit;
	shader_set(_shader);
	switch(_shader){
		case shd_bcs:
			if !(shader_is_setup(shd_bcs)){
				shader_setup(shd_bcs);
			}
			//bcs_brightness = 0.25;
			//bcs_contrast = 3;
			shader_set_uniform_f(u_brightness, bcs_brightness);
			shader_set_uniform_f(u_contrast, bcs_contrast);
		break;
	}
}

function shader_draw_end(_shader){
	if !shader_is_compiled(_shader) exit;
	shader_reset();
}