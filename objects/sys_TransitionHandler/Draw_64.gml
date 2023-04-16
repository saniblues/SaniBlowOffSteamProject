{
	var _dw = display_get_gui_width(), _dh = display_get_gui_height();
	display_set_gui_size(game_width,game_height);
	transition_alpha += 0.05 * transition_phase;
	if transition_alpha >= 1 && transition_phase == 1{
		transition_phase = -1;
		transition_alpha = 1.5;
		do_transition();
	}
	draw_set_color(c_black);
	draw_set_alpha(transition_alpha);
	draw_rectangle(0,0,game_width,game_height,0);
	draw_set_alpha(1);
	display_set_gui_size(_dw,_dh);
	
	if transition_alpha <= 0{
		instance_destroy();
		exit;
	}
}