//exit;
if !(shader_is_setup(shd_bcs)) shader_setup(shd_bcs);
if !(shader_is_setup(shd_blur)) shader_setup(shd_blur);

if bcs_brightness != bcs_brightness_goal{
	bcs_brightness = lerp(bcs_brightness,bcs_brightness_goal,0.1);	
}
if bcs_contrast != bcs_contrast_goal{
	bcs_contrast = lerp(bcs_contrast,bcs_contrast_goal,0.1);	
}
if blur_intensity != blur_intensity_goal{
	blur_intensity = lerp(blur_intensity,blur_intensity_goal,0.1);	
}
if !surface_exists(shader_surface){
	shader_surface = surface_create(game_width,game_height);	
}
if !surface_exists(final_surface){
	final_surface = surface_create(game_width,game_height);	
}
surface_copy(shader_surface,0,0,application_surface);

if menu_get(){
	blur_intensity_goal = 0.05;	
}else blur_intensity_goal = 0;
//if blur_intensity == 0{
//	  exit;	
//}


/*/
surface_set_target(final_surface);
	shader_draw_begin(shd_blur);
	draw_surface(shader_surface, 0, 0);
	shader_reset();
surface_reset_target();

shader_draw_begin(shd_bcs);
gpu_set_blendenable(false);

draw_surface(final_surface,camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]));
gpu_set_blendenable(true);
shader_reset();
/*/

gpu_set_alphatestenable(true);
gpu_set_blendmode_ext(bm_one,bm_inv_src_alpha);
surface_set_target(final_surface);
	draw_clear_alpha(c_black,0);
	gpu_set_blendenable(false);
	draw_surface(shader_surface,0,0);
	gpu_set_blendenable(true);
	
	gpu_set_blendmode(bm_subtract)
	//draw_surface(mask_surface,0,0);
	gpu_set_blendmode(bm_normal);
surface_reset_target();
gpu_set_blendmode(bm_normal);
gpu_set_alphatestenable(false);


//gpu_set_blendenable(false);
//shader_draw_begin(shd_blur);
//draw_surface(shader_surface, view_xview,view_yview);
//shader_reset();
//gpu_set_blendenable(true);
//*/