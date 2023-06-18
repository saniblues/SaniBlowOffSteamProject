{
	if (VIDEO.fullscreen) exit; // Draws to GUI instead
	var _x, _y;
	x = mouse_x;
	y = mouse_y;
	_x = lq_get(VIDEO.param, "x");
	_y = lq_get(VIDEO.param, "y");
	if is_undefined(_x) _x = x;
	if is_undefined(_y) _y = y;
	
	var _vid = video_draw();
	var _status = _vid[0];
	if (_status == 0){
		var _output = _vid[1];
		var desired_width = 160;
		var desired_height = 120;
		
		// If we just want it to stretch to fit one or the other, we can just do one "_ratio"
		//    instead of two separate ratios (ie. stretch to width/stretch to height)
		var _ratio_w = (desired_width / surface_get_width(_vid[1]));
		var _ratio_h = (desired_height / surface_get_height(_vid[1]));
		draw_surface_ext(_output,_x,_y,_ratio_w,_ratio_h,0,c_white,1);
		if video_get_position() == 0 && (VIDEO.loaded){
			trace("Video's over! Byebye!");	
			instance_destroy();
			exit;
		}
		if video_get_position() > 0 VIDEO.loaded = true;
	}else{
		trace("ERROR! Try putting video in root...");
		instance_destroy();
		exit;
	}
}