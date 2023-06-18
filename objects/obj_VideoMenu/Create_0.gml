{
	event_inherited();
		with(MenuSlider_Create_Ext(8, floor(game_height/2) + 64, "Temporary Blur", 0, 32, 3, 0, 0.50)){
		target = [obj_Camera, "blur_intensity"];
		x_goal = 64;
	}
	with(MenuSlider_Create_Ext(8, floor(game_height/2) + 64 + 9, "Temporary Blur", 0, 32, 3, -0.5, 0.5)){
		target = [obj_Camera, "bcs_brightness_goal"];
		x_goal = 64;
	}
	with(MenuSlider_Create_Ext(8, floor(game_height/2) + 64 + 18, "Temporary Blur", 0, 32, 3, -4, 20)){
		target = [obj_Camera, "bcs_contrast_goal"];
		x_goal = 64;
	}
	
	with(MenuItem_Create(8, floor(game_height/2) + 64 + 27, "Audio Menu")){
		x_goal = 64;
		on_pick = function(){
			menu_set(obj_AudioMenu);
		}
	}
	// Temporary
}