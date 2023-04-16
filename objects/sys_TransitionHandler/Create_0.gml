{
	transition_dest = {
		room : undefined,   // Room to transition to
		x : 0,              // X position
		y : 0,              // Y position
		view_direction : 1, // 1 or -1, Right or Left
		door_id : undefined // If defined, it'll pick a map_Door entity instead of x:y coords
	}
	transition_phase = 1;
	transition_alpha = 0;
	
	do_transition = function(){
		room_goto(transition_dest.room);
		schedule(2,function(){
			if !instance_exists(Player){
				instance_create(0,0,Player);	
			}
			if !is_undefined(transition_dest.door_id){
				with(map_Door){
					if image_index == other.transition_dest.door_id{
						other.transition_dest.x = x + (TILE_WIDTH/2);
						other.transition_dest.y = y + (TILE_HEIGHT/2);
					}
				}
			}
			Player.x = transition_dest.x;
			Player.y = transition_dest.y;
			Player.image_xscale = transition_dest.view_direction;
			with(obj_Camera){
				x = Player.x;
				y = Player.y;
				view_object = Player;
				view_anchor = -4;
			}
		});
	}
}