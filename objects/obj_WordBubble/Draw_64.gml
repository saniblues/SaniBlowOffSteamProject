{
	var _xp = x, _yp = y;
	x -= camera_get_view_x(view_camera[0]);
	y -= camera_get_view_y(view_camera[0]);
	x *= 2;
	y *= 2;
	draw_set_font(fntChat);
	var xoffset = 0, yoffset = 0;
	var _length = 1;
	for(var i = 1;i<string_length(text);i++){
		if string_char_at(text, i) == chr(10) || i == string_length(text) - 1{
			_length = max(_length, string_width(string_copy(text, 1, i)))
		}
	}
	for(var i = 1;i<=typewriter_progress;i++){
		if string_char_at(text, i) == chr(10){//@"\" && string_char_at(text, i + 1) == "n"{
			yoffset += 10;
			xoffset = 0;
		}else{
			draw_set_color(c_white);
			draw_text(x + xoffset - (_length/2), y + yoffset, string_char_at(text, i));
			xoffset += 10;
		}
	}
	x = _xp;
	y = _yp;
	typewriter_progress ++;
	typewriter_progress = min(typewriter_progress,string_length(text));
	if typewriter_progress >= string_length(text){
		typewriter_kill ++;
		if typewriter_kill >= room_speed * 3{
			instance_destroy();
			exit;
		}
	}
}