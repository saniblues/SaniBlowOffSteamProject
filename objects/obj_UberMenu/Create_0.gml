{
	event_inherited();
	/*
	with(MenuItem_Create(0, game_height / 2, "Audio Menu")){
		x_goal = 64;
		on_pick = function(){
			menu_set(obj_AudioMenu);	
		}
	}
	with(MenuItem_Create(0, (game_height / 2) + 64, "Video Menu")){
		x_goal = 64;
		on_pick = function(){
			menu_set(obj_VideoMenu);	
		}
	}
	*/
	var _temp = [];
	with(MenuItem_Create(16,64,"Resume Game")){
		array_push(_temp, self);
		on_pick = function(){
			menu_prune();
		}
	}
	with(MenuItem_Create(16,96,"Debug Settings")){
		array_push(_temp, self);
		on_pick = function(){
			menu_set(obj_AudioMenu);
		}
	}
	schedule(1,function(){
		var _yoff = 0;
		for(var i = 0;i<array_length(_temp);i++){
			with(_temp[i]){
				y = 64 + _yoff;
				y_goal = y;
				_yoff += bbox_top - bbox_bottom;
			}
		}
	});
}