{
	#region Scheduler
	if ds_list_size(schedule_queue) > 0{
		for(var i = 0;i<ds_list_size(schedule_queue);i++){
			var _r = true;
			var _item = schedule_queue[|i];
			if !is_lq(_item){
				_r = false;	
			}
			
			_item.timer --;
			if _item.timer <= 0{
				with(_item.source){
					// beep
				}
				try{
					with(_item.source){
						_item.func(_item.passthrough);
					}
				}catch(_error){
					trace(" ");
					trace("Error with scheduled function Source:",_item.source,"(",object_get_name(_item.source.object_index),")");
					trace("==>",_item);
					trace("==>",_error.message);
					trace("==>",_error.stacktrace[0]);
					trace("==>",_error.stacktrace[1]);
					trace(" ");
				}
				_r = false;
			}
			
			// Removes item from the list and de-increments i if completed/not found/invalid
			if !(_r){
				ds_list_delete(schedule_queue, i);
				i --;	
			}
		}
	}
	#endregion
	#region Menus
	#endregion
	// Debug
	window_set_caption(string_from_args(fps,":",fps_real));
	// Pause handler
	if button_pressed(0,KEY_ESC){
		if !instance_exists(sys_PauseContainer){
			instance_create(0,0,sys_PauseContainer);
			menu_cleanup();
			if !menu_exists(){
				//menu_set(obj_MarginMenu);
				menu_set(obj_UberMenu);
			}
		}else{
			if !menu_exists() with(sys_PauseContainer) instance_destroy();	
		}
	}
}