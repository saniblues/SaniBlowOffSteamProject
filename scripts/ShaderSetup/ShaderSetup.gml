// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/*

function draw_surface_blurred(_surface,_x,_y,_intensity){
	if !surface_exists(_surface){
		trace("ERROR: Surface called from",object_get_name(object_index),"DOES NOT EXIST!");
		trace("Check your code and try again");
		exit;
	}
	shader_set(shd_blur);
		var intensity = _intensity;
		//var _tex = surface_get_texture(application_surface);
		shader_set_uniform_f(
			shader_get_uniform(shd_blur, "size_radius"),
			game_width,game_height,intensity//texture_get_texel_width(_tex), texture_get_texel_height(_tex), intensity
			);
		var _blendable = gpu_get_blendenable();
		gpu_set_blendenable(false)
		draw_surface(application_surface, _x, _y);
		gpu_set_blendenable(_blendable)
	shader_reset();	
}
*/
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
			case shd_blur:
				shader = shd_blur;
				shd_blur_setup = true;
				u_blur = shader_get_uniform(shader, "size_radius");
				
				blur_intensity = 0;
				blur_intensity_goal = 0;
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
		case shd_blur:
			if !(shader_is_setup(shd_blur)){
				shader_setup(shd_blur);
			}
			shader_set_uniform_f(u_blur, game_width, game_height, blur_intensity)
			break;
	}
}

function shader_draw_end(_shader){
	if !shader_is_compiled(_shader) exit;
	shader_reset();
}