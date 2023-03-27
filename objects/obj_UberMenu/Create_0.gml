{
	create_frame = current_frame;
	shader_setup(shd_bcs);
	
	with(MenuSlider_Create_Ext(8, floor(game_height/2) + 32, 0, 32, 3, -2, 20)){
		target = [obj_Camera, "bcs_contrast_goal"];
	}
	with(MenuSlider_Create_Ext(8, floor(game_height/2) + 48, 0, 20, 3, -0.25, 0.25)){
		target = [obj_Camera, "bcs_brightness_goal"];
	}
	
	with(MenuSlider_Create_Ext(32, floor(game_height/2) + 56, 1, 3, 16, -2, 20)){
		target = [obj_Camera, "bcs_contrast_goal"];
	}
	with(MenuSlider_Create_Ext(48, floor(game_height/2) + 56, 1, 3, 20, -0.25, 0.25)){
		target = [obj_Camera, "bcs_brightness_goal"];
	}
}