/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

{
	candie = false;
	collisions = false;
	friction = 9999;
	last_bounce = current_frame;
	forced_state = undefined;
	multiplier = 1;
	fixed_angle = undefined;
	
	has_on_step = true;
	on_step = function(){
		hspd = 0;
		vspd = 0;
		x = xstart;
		y = ystart;
		image_xscale = lerp(image_xscale, 1, 0.20);
		image_yscale = lerp(image_yscale, 1, 0.20);
		
		if place_meeting(x,y,par_Hitme){
			with(collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,par_Hitme,0,1)){
				projectile_hit(other,0);
			}
		}
		if keyboard_check_pressed(vk_delete){
			with(Player){
				x = other.x;
				y = other.y - 32;
			}
		}
	}
	
	has_on_hit = true;
	on_hit = function(){
		//if (last_bounce <= current_frame - 20)
		{
			var _dir = point_direction(x,y,other.x + other.hspd,other.y);
			if !is_undefined(fixed_angle){
				_dir = fixed_angle;	
			}
			with(other){
				//hspd = max(max_hspd - hspd_extra, hspd);
				//vspd = max(max_vspd - vspd_extra, vspd);
				hspd = max_hspd + 1;
				vspd = max_vspd + 1;
				calc_speed_dir_ext(_dir,other.multiplier);
				//var _holding = false;
				if button_check(0,KEY_UP){
					//_holding = true;
					if diff(x,other.x) < 2{
						x = other.x;
						if !button_check(0,KEY_RIGHT) && !button_check(0,KEY_LEFT) hspd = 0;
					}
				}
				tumble_frame = current_frame;
				bounce_frame = current_frame;
				hspeed_decay_frame = current_frame + 120;
				if is_undefined(other.forced_state){
					if ((vspd > 0 && !batch_compare(moveState,movestate.doublejump,movestate.doublejump_landing)) || batch_compare(moveState,movestate.bonk,movestate.tumble)){
						moveState = (moveState == movestate.bonk ? movestate.bonk : movestate.tumble);	
					}else{
						if other.last_bounce <= current_frame - 10{
							if moveState == movestate.dropkick{
								hspd = (max_hspd + hspd_extra) * image_xscale;
								vspd = -4;
								x = other.x;
								y = other.bbox_top;
								moveState = movestate.angyjump;
							}
						}
						moveState = movestate.doublejump;
					}
				}else{
					moveState = other.forced_state;	
				}
				/*
				if !(batch_compare(moveState,movestate.dropkick,movestate.doublejump,movestate.doublejump_landing)){
					if other.last_bounce <= current_frame - 20{
						moveState = movestate.tumble;
					}
				}else{
					if other.last_bounce <= current_frame - 10{
						if moveState == movestate.dropkick{
							hspd = (max_hspd + hspd_extra) * image_xscale;
							vspd = -4;
							x = other.x;
							y = other.bbox_top;
							moveState = movestate.angyjump;
						}else moveState = movestate.doublejump_landing;
					}
				}
				*/
				/*
				if (_holding){
					vspd -= 16;
					if (abs(vspd) > max_vspd + vspd_extra){	
						vspd_extra += absdiff(abs(vspd),max_vspd + vspd_extra);
					}
				}
				*/
			}
			audio_play_sound(bounce_2,1,0);
			if batch_compare((_dir + 45) div 90, 0, 2){
				image_xscale = 0.5;
				image_yscale = 1.5;
			}else{
				image_xscale = 1.5;
				image_yscale = 0.5;
			}
			last_bounce = current_frame;
		}
	}
}