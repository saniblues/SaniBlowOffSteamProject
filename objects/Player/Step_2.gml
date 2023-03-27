{
	var _hspd_prev = hspd;
	var _xp = x - hspd, _yp = y - vspd;
	event_inherited();
	// Animation frames
	// Only a handful of cases don't use the default sprite, so we set the sprite to default here
	var _sprite_prev = sprite_index;
	sprite_index = sprEmmi_Default;
	if !batch_compare(moveState,movestate.dropkick,movestate.tumble){
		image_angle_draw = 0;
	}
	if moveState != movestate.doublejump{
		bounce_frame = 0;
	}
	var _spd = sqrt(power(hspd,2) + power(vspd,2));
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
			image_index = 14; // Temporary
			break;
		case movestate.angyjump:
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
			if place_meeting(x + _hspd_prev,y+1,par_CollisionObject){
				if place_meeting(x,y+1,par_CollisionObject) && (abs(hspd) >= max_hspd - 1 || (range(point_direction(xprevious,yprevious,x,y),190,350))){
					sprite_index = sprEmmi_SanicJump;
					image_index += 0.4;
					if image_index + image_speed >= image_number{
						image_index = 0;
						//var _snd = audio_play_sound(snd_jump_loop, 0, 0);	
						//audio_sound_gain(_snd, 0.7, 0);
					}
				}else{
					image_index = 10;
					if _ind_prev != 10{
						if !place_meeting(x,y+1,par_CollisionObject) hspd = _hspd_prev * -1;
						bounce_particles();
						audio_play_captioned_pitchvol(GoldSrcGib,random_range(0.5,2),0.5);
						audio_play_sound(bounce_2,1,0,0.4);
					}	
				}
			}else{
				image_index = 16;
				if absdiff(x,xprevious) > 1{
					if (xprevious > x){
						image_index = sign(image_xscale) ? 17 : 19;
					}else{
						image_index = sign(image_xscale) ? 19 : 17;
					}
				}
			}
			break;
		case movestate.tumble:
			image_angle_draw += (5 * min(_spd,8)) * image_xscale;
			image_index = 11;
			if place_meeting(x + _hspd_prev, y, par_CollisionObject){
				var _hspd = _hspd_prev;
				pixel_collision();
				bounce_particles();
				coyote_time = current_frame - 20;
				audio_play_sound(bounce_2,1,0,0.4);
				moveState = movestate.bonk;
				hspd = -sign(_hspd) * 3;
				vspd = -2;
				hspd_extra = 1;
				hspd_decay_frame = current_frame + 20;
			}
			break;
		case movestate.wallcling:
			image_index = 1; // Temporary
			break;
		case movestate.jump_charge:
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
			if bounce_frame <= current_frame - 30 && bounce_frame > 0{
				bounce_frame = 0;
				moveState = movestate.angyjump;
				audio_play_sound(snd_jump_angy,1,0);
			}
			break;
		case movestate.doublejump_landing:
			sprite_index = sprEmmi_SanicJump;
			image_index = ((current_frame + (animation_mod * 127375)) * 0.5) % 4;
			break;
		case movestate.dropkick:
			image_index = 1; // Temporary
			image_angle_draw = 15 * image_xscale;
			vspd = 7;
			hspd = 3 * image_xscale;
			if place_meeting(x - hspd,y+vspd,par_CollisionObject){
				pixel_collision();
				doublejump_bounce();
				coyote_time = 0;
				vspd = -1.5;
				hspd = 6 * image_xscale;
				hspd_extra = 2;
				hspd_decay_frame = current_frame + 20;
			}else if place_meeting(x + sign(image_xscale), y + vspd, par_CollisionObject){
				var _hspd = hspd;
				pixel_collision();
				if (true){ // Wall claws enabled
					moveState = movestate.wallcling;
					wallcling_button = KEY_DOWN;
					wallcling_frame = current_frame;
				}else{
					bounce_particles();
					coyote_time = current_frame - 20;
					audio_play_sound(bounce_2,1,0,0.4);
					moveState = movestate.bonk;
					hspd = -sign(_hspd) * 3;
					vspd = -2;
					hspd_extra = 1;
					hspd_decay_frame = current_frame + 20;
				}
			}
			break;
	}
}