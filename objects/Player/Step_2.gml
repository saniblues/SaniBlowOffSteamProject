{
	var _hspd_prev = hspd;
	event_inherited();
	// Animation frames
	switch(moveState){
		case movestate.idle:
			image_index = 0;
			break;
		case movestate.walk:
			image_index = (((current_frame + (animation_mod * 127375)) * image_speed) % 4);
			break;
		// Currently I just want these two to be the same
		case movestate.jump:
		case movestate.fall:
			sprite_index = sprEmmi_Default;
			image_index = 1;
			var hp = button_check(0,KEY_RIGHT) - button_check(0,KEY_LEFT);
			var _half = (bbox_right - bbox_left) / 2;
			if collision_point(x + ((1 + _half) * image_xscale), y, par_CollisionObject, 0, 1) && ( collision_point(x + ((1 + _half) * image_xscale), bbox_top, par_CollisionObject, 0, 1) && collision_point(x + ((1 + _half) * image_xscale), bbox_bottom, par_CollisionObject, 0, 1)){
				if abs(hp) && vspd > 0 vspd = 0.5;
				if button_pressed(0,(sign(hp) ? KEY_RIGHT : KEY_LEFT)){
					moveState = movestate.wallcling;
					cling_direction = image_xscale;
				}
			}
			break;
		case movestate.slide:
			sprite_index = sprEmmi_Default;
			image_index = 14; // Temporary
			break;
		case movestate.angyjump:
			sprite_index = sprEmmi_Default;
			image_index = 12;
			if abs(_hspd_prev) >= 2{
				if collision_point(x+_hspd_prev,y,par_CollisionObject,0,1){
					if !is_undefined(has_on_bonk){
						if (has_on_bonk){
							on_bonk();	
						}
					}
					hspd = _hspd_prev * -0.33;
				}
			}
			break;
		case movestate.hitstun:
		case movestate.bonk:
			var _ind_prev = floor(image_index);
			sprite_index = sprEmmi_Default;
			image_index = 16;
			if absdiff(x,xprevious) > 1{
				if (xprevious > x){
					image_index = sign(image_xscale) ? 17 : 19;
				}else{
					image_index = sign(image_xscale) ? 19 : 17;
				}
			}
			if place_meeting(x,y+1,par_CollisionObject){
				image_index = 10;
				if _ind_prev != 10{
					bounce_particles();
					audio_play_sound(bounce_2,1,0,0.4);
				}
			}
			break;
		case movestate.wallcling:
			sprite_index = sprEmmi_Default;
			image_index = 1; // Temporary
			break;
		case movestate.jump_charge:
			sprite_index = sprEmmi_Default;
			image_index = 14;
			break;
		case movestate.doublejump:
			sprite_index = sprEmmi_SanicJump;
			image_index += 0.4;
			if image_index + image_speed >= image_number{
				image_index = 0;
				var _snd = audio_play_sound(snd_jump_loop, 0, 0);	
				audio_sound_gain(_snd, 0.7, 0);
			}
			/*
			image_index_previous = ((current_frame - 1 + (animation_mod * 127375)) * 0.6) % 4;
			image_index = ((current_frame + (animation_mod * 127375)) * 0.7) % 4;
			*/
			/*
			if image_index_previous >= 3 && image_index <= 1{
				
			}
			*/
			var _half = (bbox_right - bbox_left) / 2;
			var hp = button_check(0,KEY_RIGHT) - button_check(0,KEY_LEFT);
			if collision_point(x + ((1 + _half) * image_xscale), y, par_CollisionObject, 0, 1) && ( collision_point(x + ((1 + _half) * image_xscale), bbox_top, par_CollisionObject, 0, 1) && collision_point(x + ((1 + _half) * image_xscale), bbox_bottom, par_CollisionObject, 0, 1)){
				if button_pressed(0,(sign(hp) ? KEY_RIGHT : KEY_LEFT)){
					moveState = movestate.wallcling;
					cling_direction = image_xscale;
				}
			}
			break;
		case movestate.doublejump_landing:
			sprite_index = sprEmmi_SanicJump;
			image_index = ((current_frame + (animation_mod * 127375)) * 0.5) % 4;
			break;
	}
}