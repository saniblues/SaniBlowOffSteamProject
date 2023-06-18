// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function draw_surface_blurred(_surface, _x, _y){
	if !surface_exists(_surface) exit;
	if !(shader_is_setup(shd_blur)) shader_setup(shd_blur);
	var _bi = blur_intensity, _bg = blur_intensity_goal;
	blur_intensity_goal = 0.025;
	blur_intensity = 0.025;
	shader_draw_begin(shd_blur)
	draw_surface(_surface, _x, _y);
	shader_draw_end(shd_blur);
	blur_intensity = _bi;
	blur_intensity_goal = _bg;
}