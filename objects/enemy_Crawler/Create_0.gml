/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
{
	cooldown_frame = current_frame;
	x = round(x);
	y = round(y);
	x_goal = x div TILE_WIDTH;
	y_goal = y div TILE_HEIGHT;
	image_angle_draw = image_angle;
	image_angle = 0;
	_direction = image_angle_draw - 90;
	clinging = true;
	team = 2;
	has_on_step = true;
	last_bounce = current_frame;
	slave_id = -4;
	
	on_step = function(){
		if (clinging){
			//if image_angle_draw == _direction
			image_xscale_draw = 1 + (cos(current_frame / 15) / 4);
			image_yscale_draw = 1 - (cos(current_frame / 15) / 4);
			var _r = false;
			var _amount = 1;
			if place_meeting(x+lengthdir_x(_amount,_direction), y + lengthdir_y(_amount,_direction),par_CollisionObject){
				// A wall is impeding your path; Scan for new path
				_r = true;
			}else{
				// Collision with surface in intended direction is NOT found; Scan 90 degrees at your feet for collisions
				if !place_meeting(x+lengthdir_x(_amount,_direction - 90), y + lengthdir_y(_amount,_direction - 90),par_CollisionObject)
				&& !place_meeting(x+lengthdir_x(_amount,_direction - 45), y + lengthdir_y(_amount,_direction - 45),par_CollisionObject){
					_r = true
				}
			}
			// Some impediment to your movement is detected; Scan counter-clockwise for a new surface
				// Note a flaw in this; I need to make it scan both ways so they aren't literally one-directional enemies
			if (_r){
				var _xp = x, _yp = y;
				var _val = 45;
				repeat((360/_val)){
					_direction += _val;
					if (
						place_meeting(x + lengthdir_x(TILE_WIDTH/2,_direction - _val), y + lengthdir_y(TILE_HEIGHT/2,_direction - _val),par_CollisionObject)
					)
					&& !place_meeting(x + lengthdir_y(TILE_WIDTH/2, _direction), y + lengthdir_y(TILE_HEIGHT/2,_direction),par_CollisionObject){
						break;	
					}
				}
				_direction = _direction % 360;
				move_contact_solid(_direction - 90, 2);
				x = _xp; y = _yp;
			}
			// Always set speed, regardless
			set_speed_dir(0.5,_direction);
			//set_speed_dir(max(0,(image_yscale_draw - 0.9) * 2),_direction)
			// Adjust image angle to match direction
			image_angle_draw += angle_difference(_direction, image_angle_draw) * 0.15;
			if absdiff(image_angle_draw,_direction) <= 1{
				image_angle_draw = _direction;	
			}
			// WHERE IS THE FLOOR?!
			if !place_meeting(x+lengthdir_x(8,_direction - 90), y+lengthdir_y(8,_direction-90), par_CollisionObject){
				// WHERE IS THE *FUCKING* FLOOR?!?!?!?!?!!!!
				if !place_meeting(x+lengthdir_x(8,_direction+45), y+lengthdir_y(8,_direction+45), par_CollisionObject)  && !place_meeting(x+lengthdir_x(8,_direction - 45), y+lengthdir_y(8,_direction-45), par_CollisionObject) {
					//	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
					clinging = false;	
				}
			}
		}else{
			// Not clinging; Succumb to gravity
			vspd += GRAV_FACTOR;
			// Spin
			image_angle_draw += max(5,sqrt(power(hspd,2) + power(vspd,2)) * 5);
			// Cling to a wall if we hit it
			var _dir = point_direction(xprevious,yprevious,x,y);
			if place_meeting(x + hspd, y + vspd,par_CollisionObject){
				clinging = true;
				_direction = _dir;
			}
		}
		if place_meeting(x,y,par_Hitme){
			with(collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,par_Hitme,0,1)){
				if team != other.team{
					projectile_hit_ext(other,0,true,0,0);
				}
			}
		}
		debug_drag_step();
	}
	has_on_hit = true;
	on_hit = function(){
		var _boost = my_health <= 0;
		var _dir = point_direction(x,y,other.x,other.y);
		nexthurt += 3;
		with(other){
			//hspd = max(max_hspd - hspd_extra, hspd);
			//vspd = max(max_vspd - vspd_extra, vspd);
			var _prev = sign(vspd);
			var _vp = vspd, _hp = hspd;
			hspd = max_hspd - 1;
			vspd = max_vspd - 1;
			hspd_decay_frame = current_frame + 5;
			//calc_speed_dir(_dir + (angle_difference(_dir,other._direction + 90) * 0.80));
			calc_speed_dir(other._direction + 90 - (angle_difference(other._direction + 90, _dir)/1.25));
			if (vspd >= 0 && bbox_bottom - _vp < other.bbox_bottom){
				hspd = _hp;
				vspd = min(vspd,-4);
				moveState = movestate.doublejump;
			}
			/*
			if (vspd < 0 && y - _vp < other.y){
				hspd = _hp;
				vspd = min(vspd,-4);
				moveState = movestate.doublejump;
			}else{
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
							moveState = movestate.angyjump;
						}
					}
					moveState = movestate.doublejump;
				}
			}
			*/
		}
		audio_play_sound(bounce_2,1,0);
		/*
		if batch_compare((_dir + 45) div 90, 0, 2){
			image_xscale_draw = 0.5;
			image_yscale_draw = 1.5;
		}else{
			image_xscale_draw = 1.5;
			image_yscale_draw = 0.5;
		}
		*/
		last_bounce = current_frame;
	}
}