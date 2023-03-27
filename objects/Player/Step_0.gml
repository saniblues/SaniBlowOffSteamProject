{
	event_inherited();
	var maxvspd = max_vspd + vspd_extra;
	
	/*
	if moveState == movestate.doublejump{
		sprite_index = sprEmmi_SanicJump;
		image_index = ((current_frame + (animation_mod * 127375)) * 0.8) % 4;
		var _half = (bbox_right - bbox_left) / 2;
		var hp = button_check(0,KEY_RIGHT) - button_check(0,KEY_LEFT);
		if collision_point(x + ((1 + _half) * image_xscale), y, par_CollisionObject, 0, 1) && ( collision_point(x + ((1 + _half) * image_xscale), bbox_top, par_CollisionObject, 0, 1) && collision_point(x + ((1 + _half) * image_xscale), bbox_bottom, par_CollisionObject, 0, 1)){
			if button_pressed(0,(sign(hp) ? KEY_RIGHT : KEY_LEFT)){
				moveState = movestate.wallcling;
				cling_direction = image_xscale;
			}
		}
		if place_meeting(x,y+1,par_CollisionObject){
			trace("YES",current_frame)
			moveState = movestate.doublejump_landing;
			vspd = -1;
		}	
	}
	*/
	if moveState == movestate.hitstun{
		hitstun_timer --;
		if hitstun_timer <= 0{
			moveState = movestate.idle;	
		}
	}else if moveState == movestate.bonk{
		hitstun_timer = 30;	
		if place_meeting(x,y+1,par_CollisionObject){
			moveState = movestate.hitstun;	
		}
	}
	if place_meeting(x,y+1,par_CollisionObject){
		if tumble_frame > 0{
			tumble_frame = 0;
			hspeed_decay_frame = 0;
		}	
	}
	if !batch_compare(moveState,movestate.wallcling){
		if !place_meeting(x,y+1,par_CollisionObject){
			vspd += GRAV_FACTOR;
			if !batch_compare(moveState,movestate.tumble,movestate.dropkick,movestate.doublejump,movestate.doublejump_landing,movestate.angyjump,movestate.fall,movestate.hitstun,movestate.bonk,movestate.jump_charge){
				moveState = movestate.jump;
			}
		}else{
			// If touching ground
			if batch_compare(moveState,movestate.jump,movestate.angyjump,movestate.fall){//,movestate.jump_charge){
				moveState = movestate.idle;
				sprite_index = sprEmmi_Default;
			}else if moveState == movestate.doublejump{
				doublejump_bounce();
			}else if moveState == movestate.doublejump_landing{
				if vspd < maxvspd{
					if vspd >= 0{
						moveState = movestate.idle;
						sprite_index = sprEmmi_Default;
					}
					if place_meeting(x,y+1,par_CollisionObject){
						y --;
						if vspd == -1{
							vspd = 0;	
						}
						moveState = movestate.idle;
						sprite_index = sprEmmi_Default;
					}
				}else{
					// Bounce again because you're going too fast
					doublejump_bounce();
				}
			}else if moveState == movestate.tumble{
				image_angle_draw = (image_angle_draw + 360) % 360;
				if image_angle_draw <= 45 || image_angle_draw >= 315{
					doublejump_bounce();
					//moveState = movestate.idle;
					//sprite_index = sprEmmi_Default;
				}else{
					moveState = movestate.hitstun;
					hitstun_timer = 10;
					bounce_particles();
				}
			}
		}
		if abs((vspd + hspd) / 2) <= 0.2 && batch_compare(moveState,movestate.idle,movestate.walk){
			moveState = movestate.idle;	
		}
	}else{
		if moveState == movestate.wallcling{
			vspd = 0;
			coyote_time = current_frame;
			if button_check(0,KEY_DOWN){
				vspd = 1;	
			}
			var hp = button_check(0,KEY_RIGHT) - button_check(0,KEY_LEFT);
			if (hp != cling_direction && !button_check(0,wallcling_button)) || !collision_point(x + (image_xscale * 16), y, par_CollisionObject,0,1){
				moveState = movestate.jump;
				wallcling_button = KEY_SELECT;
			}else{
				if button_check(0,KEY_RIGHT){
					wallcling_button = KEY_RIGHT;	
				}
				if button_check(0,KEY_LEFT){
					wallcling_button = KEY_LEFT;	
				}
			}
		}
	}
}