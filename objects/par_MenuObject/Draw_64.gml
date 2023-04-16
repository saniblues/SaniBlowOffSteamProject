{
	if button_pressed(0,KEY_ESC) && create_frame < current_frame{
		if menu_get() == id{
			menu_prune();
		}
	};
	
	var _dw = display_get_gui_width(), _dh = display_get_gui_height();
	display_set_gui_size(window_get_width()/2,window_get_height()/2);
	if !ds_exists(MenuItem, ds_type_list) exit;
	
	if ds_list_size(MenuItem) <= 0{
		trace("Empty UberMenu. Something is wrong?");
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
					delete other.MenuItem[|i];
					ds_list_delete(other.MenuItem,i);
					i --;
				}
			}
		}
	}
	display_set_gui_size(_dw,_dh);
}