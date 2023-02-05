{
	debug_drag_step();
	var accel_speed = 1; // temporary
	var jump_strength = -4; // temporary
	var maxhspd = 2.25 + hspd_extra; // temporary
	var maxvspd = 4 + hspd_extra; // temporary
	var hp = button_check(0, KEY_RIGHT) - button_check(0, KEY_LEFT);
	var vp = button_check(0, KEY_DOWN) - button_check(0,KEY_UP);
	if gameState == gamestate.idle{
		if abs(hp) && !batch_compare(moveState, movestate.jump_charge, movestate.slide, movestate.hitstun, movestate.bonk){
			hspd += accel_speed * hp;
			image_xscale = sign(hp);
			if place_meeting(x,y+1,par_CollisionObject) && moveState = movestate.idle && !batch_compare(moveState, movestate.doublejump, movestate.jump_charge, movestate.hitstun,movestate.bonk){//moveState != movestate.doublejump{
				moveState = movestate.walk;	
			}
		}
		/*
		if abs(vp){
			vspd += accel_speed * vp;	
		}
		/*/
		if place_meeting(x, y+1, par_CollisionObject){
			coyote_time = current_frame;
		}
		var _accelerator = /*item_get_enabled("Accelerator")*/ accelerator_enabled && batch_compare(moveState,movestate.jump,movestate.angyjump,movestate.doublejump,movestate.doublejump_landing)
		if button_check(0,KEY_UP) && (batch_compare(moveState,movestate.jump,movestate.doublejump_landing) || _accelerator) && vspd >= 0 && place_meeting(x,y+vspd,par_CollisionObject){
			moveState = movestate.jump_charge;
			//show_message("JUMP CHARGE");
		}
		if (moveState == movestate.jump_charge){
			// Cancel the charge specifically by moving
			if button_pressed(0,KEY_LEFT) || button_pressed(0,KEY_RIGHT) && place_meeting(x,y+1,par_CollisionObject){
				moveState = movestate.walk;	
			}
		}
		if button_released(0,KEY_UP) && moveState == movestate.jump_charge{
			if hspd_extra <= 2.75{
				hspd_extra += 2.75;
			}else{
				hspd_extra *= 1.75;	
			}
			maxhspd += hspd_extra;
			hspd = (maxhspd + hspd_extra) * sign(image_xscale);
			hspd_decay_frame = current_frame + 20;
			jump_strength /= 2;
			vspd = jump_strength;
			repeat(6){
				with(instance_create(x + (hspd * 2),y,par_Effect)){
					direction = 90 + (90 * other.image_xscale) + (random(15) * -other.image_xscale);
					speed = random_range(1,3);
				}
			}
			audio_play_sound(snd_jump_angy,1,0);
			y --;
			moveState = movestate.angyjump;
		}
		if button_pressed(0,KEY_UP) && (batch_compare(moveState, movestate.idle, movestate.walk, movestate.jump, movestate.jump_charge, movestate.doublejump) || (moveState == movestate.doublejump_landing && coyote_time >= current_frame + 20)){
			if moveState != movestate.doublejump /*|| !jump_avail*/{
				/*
				if (moveState == movestate.doublejump_landing){
					hspd = maxhspd * sign(image_xscale);
					hspd_extra = 2;
					hspd_decay_frame = current_frame + 20;
					jump_strength /= 2;
				}
				*/
				moveState = movestate.jump;
				if place_meeting(x, y+1, par_CollisionObject) || coyote_time > current_frame - 15{
					vspd = jump_strength;
					var _snd = audio_play_sound(snd_jump_start_new,1,0,0.8);
					audio_sound_pitch(_snd,1)
				}
				if coyote_time <= current_frame - 15 && !place_meeting(x, y+1, par_CollisionObject){
					moveState = movestate.doublejump;
					vspd = jump_strength;
				}
				coyote_time = current_frame - 20;
				/*
				vspd = jump_strength;
				if !place_meeting(x, y+1, par_CollisionObject) && batch_compare(moveState,movestate.idle,movestate.walk,movestate.jump){
					moveState = movestate.doublejump;	
				}
				*/
			}else{
				moveState = movestate.angyjump;	
				vspd = -2.5;
				hspd += sign(hspd) * 2;
				audio_stop_sound(snd_jump_loop);
				audio_play_sound(snd_jump_angy,1,0,0.7);
			}
		}
	}
	//*/
	hspd = clamp(-maxhspd, hspd, maxhspd);
	vspd = clamp(-maxvspd, vspd, maxvspd);
}