/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

{
	candie = true;
	collisions = false;
	friction = 9999;
	last_bounce = current_frame;
	slime_eject_frame = current_frame;
	creator = -4;
	slave_id = -4;
	descend_timer = 0;
	my_health = 3;
	image_scale = 0;
	blorb = 2;
	has_on_step = true;
	on_step = function(){
		/*
		hspd = 0;
		vspd = 0;
		x = xstart;
		y = ystart;
		*/
		image_scale = min(1, image_scale + 0.0125);
		if image_scale < 1{
			if (blorb && !--blorb){
				image_xscale = choose(1.45,0.55);
				image_yscale = (image_xscale == 1.45 ? 0.55 : 1.45);
				image_speed = 0;
				image_xscale = lerp(image_xscale, image_scale, 0.2);
				image_yscale = lerp(image_yscale,image_scale, 0.2);
				blorb = 2;
			
			}
		}else image_angle_draw = 0;
		
		if instance_exists(slave_id){
			vspd = max(vspd - 0.0125, -0.3);
		}else{
			if point_distance(x,y,x,ystart) <= 0.1{
				vspd = 0;
				y = ystart;
			}else{
				if absdiff(y,ystart) <= 6{
					vspd = 0;
					y = lerp(y,ystart,0.1);
				}else vspd = min(vspd + (0.005 * (y > ystart ? -1 : 1)), 0.3);
			}
		}
		if place_meeting(x,y + vspd,par_CollisionObject){
			projectile_hit(id,9999);
			exit;
		}
		image_xscale = lerp(image_xscale, 1, 0.20);
		image_yscale = lerp(image_yscale, 1, 0.20);
		if instance_exists(slave_id){
			with(slave_id){
				x = lerp(x,other.x,0.33);
				y = lerp(y,other.y,0.33);
				hspd = 0;
				vspd = 0;
				other.depth = depth + 1;
				image_angle_draw += 1 * image_xscale;
				if instance_is(id,Player){
					if button_pressed(0,KEY_UP){
						moveState = movestate.jump;
						vspd = -max_vspd;
						other.slave_id = -4;
						other.last_bounce = current_frame;
						other.slime_eject_frame = current_frame;
						audio_play_sound(snd_jump_start,1,0);
						audio_play_sound(bounce_2,1,0);
					}
				}
			}
		}
		if place_meeting(x,y,par_Hitme){
			with(collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,par_Hitme,0,1)){
				var _dmg = (id == other.slave_id ? 0 : 1);
				if other.slime_eject_frame <= current_frame - 20{
					projectile_hit(other,_dmg);
				}
			}
		}
		if keyboard_check_pressed(vk_delete){
			with(Player){
				x = other.x;
				y = other.y - 32;
			}
		}
	}
	has_on_destroy = true;
	
	on_destroy = function(){
		if !instance_exists(creator){
			respawn(room_speed * 5);
		}
	}
	
	has_on_hit = true;
	on_hit = function(){
		//if (last_bounce <= current_frame - 20)
		{
			var _boost = my_health <= 0;
			if other.id == slave_id exit;
			if slime_eject_frame >= current_frame - 20 exit;
			var _dir = point_direction(x,y,other.x,other.y)
			with(other){
				//hspd = max(max_hspd - hspd_extra, hspd);
				//vspd = max(max_vspd - vspd_extra, vspd);
				var _prev = sign(vspd);
				var _vp = vspd, _hp = hspd;
				hspd = max_hspd + 1;
				vspd = max_vspd + 1;
				calc_speed_dir(_dir);
				if (vspd < 0 && y - _vp < other.y){
					y = other.bbox_top;
					hspd = _hp;
					vspd = min(vspd,-4);
					moveState = movestate.doublejump;
				}else{
					//var _holding = false;
					if button_check(0,KEY_UP){
						//_holding = true;
						if (y < other.y){
							if diff(x,other.x) < 2{
								x = other.x;
								if !button_check(0,KEY_RIGHT) && !button_check(0,KEY_LEFT) hspd = 0;
							}
						}else{
							// Enter the bubble instead of bouncing on it
							if !instance_exists(other.slave_id) && other.last_bounce < current_frame - 30{
								other.slave_id = id;
								moveState = movestate.tumble;
								other.last_bounce = current_frame;
								other.my_health = 3;
								audio_play_sound(Bounce,1,0);//,1,0,0.5);
								exit;
							}
						}
					}
					tumble_frame = current_frame;
					bounce_frame = current_frame;
					hspeed_decay_frame = current_frame + 120;
					if ((vspd > 0 && !batch_compare(moveState,movestate.doublejump,movestate.doublejump_landing)) || moveState == movestate.tumble){
						moveState = movestate.tumble;	
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