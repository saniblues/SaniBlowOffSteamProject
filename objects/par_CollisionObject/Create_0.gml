{
	image_speed = 0;
	vspd = 0;
	hspd = 0;
	destructible = false;
	tried = false;
	parent_block = true;
	chain_destroy_array = [];
	chain_destroy = function(_array){
		if !(destructible) exit;
		destructible = false;
		
		for(var i = -1;i<=1;i+=1){
			for(var o = -1;o<=1;o+=1){
				if !(i == 0 && o == 0){
					with(collision_point(x + 8 + (16 * i), y + 8 + (16 * o), par_CollisionObject, 0, 1)){
						if (destructible){
							schedule(5, function(){
								chain_destroy();	
								}
							);
						}
					}
				}
			}
		}
		
		destroy();
	}
	destroy = function(){
		audio_stop_sound(snd_jump_start);
		audio_play_sound(snd_jump_start,1,0);
		instance_destroy();	
	}
}