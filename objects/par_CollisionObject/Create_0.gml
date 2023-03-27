{
	function collision_tile_at(_x, _y, _useAny){
		_x = _x div 16;
		_y = _y div 16;
		with(par_CollisionObject){
			if (xstart div 16 == _x && ystart div 16 == _y){
				return id;	
			}
		}
		return -4;
	}
	image_speed = 0;
	vspd = 0;
	hspd = 0;
	destructible = false;
	actually_destructible = true;// Not really
	actually_solid = true;
	made_for_level = false;
	tried = false;
	parent_block = true;
	chain_destroy_array = [];
	schedule(1,function(){
		if !(actually_solid){
				mask_index = mskNone;
			}
		}
	);
	chain_destroy = function(_array){
		if !(destructible) exit;
		destructible = false;
		for(var i = -1;i<=1;i+=1){
			for(var o = -1;o<=1;o+=1){
				if !(i == 0 && o == 0){
					with(collision_tile_at(xstart + 8 + (16 * i), ystart + 8 + (16 * o), false)){
					//with(collision_point(x + 8 + (16 * i), y + 8 + (16 * o), par_CollisionObject, 0, 1)){
						if (destructible || !actually_solid){
							schedule(5, function(){
								chain_destroy();	
								}
							);
						}
					}
				}
			}
		}
		if (actually_destructible) destroy();
	}
	destroy = function(){
		audio_stop_sound(snd_jump_start);
		audio_play_sound(snd_jump_start,1,0);
		instance_destroy();	
	}
}