{
	//trace("I EXIST",object_get_name(object_index),current_frame);
	if !SETTING.debug.allow_tracelog exit;
	if (button_pressed(9999,KEY_ESC) || keyboard_check_pressed(vk_control)) && create_frame < current_frame{
		if menu_get() == id{
			menu_prune();
		}
	};
	/*
	// This was written in response to something Chi sent me pertaining to displaying items in CGs
	var _wid = sprite_get_width(s_Icon_FloppyDisk) * 2;
	var _xst = game_width/2, _yst = game_height/3 + (_wid/2);
	draw_set_color(c_lime);
	draw_rectangle(_xst - (72/2), _yst - (72/2), _xst + (72/2), _yst + (72/2), 0);
	draw_set_color(c_white);
	draw_sprite_ext(s_Icon_FloppyDisk, 0, game_width/2 - (_wid/2),game_height/3, 2, 2, 0, c_white, 1);
	*/
	var _dw = display_get_gui_width(), _dh = display_get_gui_height();
	display_set_gui_size(window_get_width()/2,window_get_height()/2);
	if !ds_exists(MenuItem, ds_type_list){
		display_set_gui_size(_dw,_dh);
		exit;
	}
	if ds_list_size(MenuItem) <= 0{
		trace("Empty UberMenu. Something is wrong?");
		display_set_gui_size(_dw,_dh);
		instance_destroy();
		exit;
	}
	for(var i = 0;i<ds_list_size(MenuItem);i++){
		if !is_lq(MenuItem[|i]){
			delete MenuItem[|i];
			ds_list_delete(MenuItem,i);
			i --;
		}else{
			with(MenuItem[|i]){
				// On_Draw event
				// If this is undefined, or fails to execute, it will prune this item from the list
				if !(cleanup){
					if !is_undefined(on_draw){
						try{
							on_draw();	
						}catch(_error){
							show_message(_error);
							delete other.MenuItem[|i];
							other.MenuItem[|i] = -1;
							i --;
						}
					}else{
						other.MenuItem[|i] = -1;
						i --;	
					}
				
					if !is_undefined(on_draw_post){
						try{
							on_draw_post();	
						}catch(_error){
							//	
						}
					}
				}else{
					if !menu_stored(other){
						delete other.MenuItem[|i];
						ds_list_delete(other.MenuItem,i);
						i --;
					}
				}
			}
		}
	}
	display_set_gui_size(_dw,_dh);
}