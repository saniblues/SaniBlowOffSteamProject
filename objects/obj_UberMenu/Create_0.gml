{
	event_inherited();
	with(MenuItem_Create(0, game_height / 2, "Audio")){
		x_goal = 64;
		on_pick = function(){
			menu_set(obj_AudioMenu);	
		}
	}
}