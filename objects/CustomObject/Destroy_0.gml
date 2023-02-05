{
	// Custom destruction
	if !is_undefined(on_destroy){
		try{
			on_destroy();	
		}catch(_error){
			trace("Invalid on_destroy event for", object_get_name(object_index), "!");
		}
	}
}
