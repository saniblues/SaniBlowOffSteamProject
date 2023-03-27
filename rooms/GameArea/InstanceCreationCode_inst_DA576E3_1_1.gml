{
	moveState = movestate.tumble;
	vspd = max_vspd;
	with(script_bind()){
		xstart = other.xstart;
		ystart = other.ystart;
		creator = other.id;
		has_landed = false;
		start = false;
		finished = false;
		on_step = function(){
			if !instance_exists(creator){
				instance_destroy();
				exit;
			}
			if keyboard_check_pressed(vk_pageup){
				start = true;	
			}
			if keyboard_check_pressed(vk_pagedown){
				with(creator){
					moveState = movestate.tumble;
					vspd = max_vspd;
				}
				start = false;
				finished = false;
			}
			if !(finished){
				with(creator){
					if !other.start{
						y = other.ystart;
						x = other.xstart;
					}else{
						hitstun_timer = room_speed * 5;	
					}
					if place_meeting(x,y+1,par_CollisionObject) && vspd == 0 && hspd == 0{
						moveState = movestate.hitstun;
						hitstun_timer = room_speed * 5;
						other.finished = true;
						trace("FINISHED!");
					}
				}
			}
		}
	}
}