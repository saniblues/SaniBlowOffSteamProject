{
	//draw_sprite(sprite_index,image_index,x,y);
	if !(instance_exists(creator)){
		instance_destroy();
		exit;
	}
	x = creator.x; y = creator.y;
	direction = creator.direction;
	if variable_instance_exists(creator,"hspd"){
		hspd = creator.hspd;
		vspd = creator.vspd;
	}else{
		speed = creator.speed;	
	}
	sprite_index = creator.sprite_index;
	mask_index = creator.mask_index;
	// If inputs are paused, assumes false
	var _draw = (input_level_is_paused(0) ? false : (place_meeting_grid(x,y,Player) && !(active)));
	if (_draw){
		image_alpha += 0.05;
		image_alpha = min(1, image_alpha);
		if button_pressed(0,KEY_DOWN){
			active = true;
			if !is_undefined(has_on_pick){
				if(has_on_pick){
					on_pick();
				}
			}else{
				try{
					with(id) on_pick();
					has_on_pick = true;
				}catch(error){
					has_on_pick = false;
					if !is_real(on_pick) || (is_real(on_pick) && on_pick != -1){
						trace("ERROR WITH on_pick EVENT");
						trace("==>",error.message);
						trace("==>",error.stacktrace[0]);
						trace("==>",error.stacktrace[1]);
					}
				}
			}
		}
	}else{
		image_alpha -= 0.05;
		image_alpha = max(0, image_alpha);
	}
	draw_sprite_ext(sprSpinnyBubble,current_frame * 0.20, x + (bbox_right - bbox_left) / 2, bbox_top - image_alpha, 1, 1, 0, c_white, image_alpha);
}