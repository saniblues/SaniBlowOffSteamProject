{
	// Note for later: This object's sprite will later be made into a generic
	//  16x16 sprite to make it easier to fit into the editor
	dest_raw = [room, x, y];
	dest_tiled = function(_room, _x, _y){
		dest_raw = [
			room_exists(_room) ? _room : room,
			round(_x * TILE_WIDTH),
			round(_y * TILE_HEIGHT)
		]
	}
	depth += 99;
	schedule(1, function(){
		with(instance_create(x,y,par_Prompt)){
			creator = other;
			on_pick = function(){
				if !instance_exists(creator) exit;
				input_level_pause(0);
				with(creator){
					/*
						with(instance_create(0,0,obj_TransitionHandler)){
							dest_raw = other.dest_raw;
						}
					*/
					// All of the below is temporary
					if dest_raw[0] != room{
						// Temporary
						room_goto(dest_raw[0]);
					}else{
						// Also temporary
						with(Player){
							x = other.dest_raw[1];
							y = other.dest_raw[2];
						}
					}
				}
				schedule(room_speed, function(){
						//trace("HELLO WORLD!");
						input_level_resume(0);
						active = false;
					}
				);
			}
		}
	}
	);
}