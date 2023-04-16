{
	event_inherited();
	with(MenuSlider_Create_Ext(8, floor(game_height/2) + 32, "BGM Volume", 0, 32, 3, 0, 1)){
		target = [SETTING.audio, "mus_volume"];
		x_goal = 64;
	}
	with(MenuSlider_Create_Ext(8, floor(game_height/2) + 48, "SFX Volume", 0, 32, 3, 0, 1)){
		target = [SETTING.audio, "sfx_volume"];
		x_goal = 64;
	}
	with(MenuItem_Create(8, floor(game_height/2) + 48 + 9, "Closed Captioning")){
		target = [SETTING.audio, "captioning"];
		x_goal = 64;
	}
	
	with(MenuItem_Create(8, floor(game_height/2) + 48 + 9, "Closed Captioning")){
		x_goal = 64;
		on_pick = function(){
			menu_set(obj_VideoMenu);
		}
	}
	// Temporary
}