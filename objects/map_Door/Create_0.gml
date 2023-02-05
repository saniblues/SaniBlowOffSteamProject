{
	// dest_tiled(_room, _x, _y)
	// converts the array used in dest_raw to use tiled coordinates
	dest_tiled = function(_room, _x, _y){
		dest_raw = [
			room_exists(_room) ? _room : room,
			round(_x * TILE_WIDTH) + (TILE_WIDTH/2),
			round(_y * TILE_HEIGHT) + (TILE_HEIGHT/2)
		]
	}
	
	dest_raw = [room, x + (TILE_WIDTH/2), y + (TILE_HEIGHT/2)];
	use_dest_coords = false;
	dest_room = room;
	
	
	image_speed = 0;
	depth += 99;
	schedule(1, function(){
		with(instance_create(x,y,par_Prompt)){
			creator = other;
			on_pick = function(){
				if !instance_exists(creator) exit;
				input_level_pause(0);
				with(creator){
					if (use_dest_coords){
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
					}else{
						if (dest_room != room){
							
						}else{
							// It's sending you to a random door of the same image index
							// I don't think this'll come up gameplay-wise, just idiot-proofing my work
							var _id = id;
							var _ar = [];
							with(map_Door) if image_index == other.image_index && id != _id array_push(_ar, id);
							if array_length(_ar) > 0{
								with(_ar[irandom(array_length(_ar)-1)]){
									if image_index == other.image_index && id != _id{
										with(Player){
											x = other.x + TILE_WIDTH/2;
											y = other.bbox_bottom - sprite_get_yoffset(mask_index == -1 ? sprite_index : mask_index);
										}
									}
								}
							}
						}
					}
				}
				schedule(room_speed/4, function(){
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