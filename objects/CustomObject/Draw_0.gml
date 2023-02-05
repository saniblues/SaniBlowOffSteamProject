{
	// Is there an on_draw event? Try running it here!
	if is_undefined(has_on_draw){
		try{
			on_draw();
			has_on_draw = true;
		}catch(_error){
			has_on_draw = false;
			trace("on_draw FAILED TO COMPILE");
			trace("==>",_error.message);
			trace("==>",_error.stacktrace[0]);
			trace("==>",_error.stacktrace[1]);
		}
	}else{
		if (has_on_draw){
			on_draw();	
		}
	}
}