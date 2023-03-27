{
	display_set_gui_size(game_width,game_height);
	if ds_list_size(MenuItem) <= 0{
		trace("Empty UberMenu. Something is wrong?");
		instance_destroy();
		exit;
	}
	for(var i = 0;i<ds_list_size(MenuItem);i++){
		if !is_lq(MenuItem[|i]){
			ds_list_delete(MenuItem,i);
			i --;
		}else{
			with(MenuItem[|i]){
				// On_Draw event
				// If this is undefined, or fails to execute, it will prune this item from the list
				if !is_undefined(on_draw){
					try{
						on_draw();	
					}catch(_error){
						show_message(_error);
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
			}
		}
	}
}