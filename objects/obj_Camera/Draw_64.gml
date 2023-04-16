{
	// This is banners for the menus
	// Currently exiting out of this code so it isn't running for LITERALLY no reason (this should go in a proper object instead of the camera)
	exit;
	//
	
	var _dw = display_get_gui_width(), _dh = display_get_gui_height();
	display_set_gui_size(game_width * 2,game_height * 2);
	
	var _spr = sprPause_Front, _bak = sprItem_Back, _baker = sprPause_Backer;
	var _wid = sprite_get_width(_bak), _hig = sprite_get_height(_bak);
	var _xoff = (current_frame/2) % _wid;
	var _alpha = abs(sin(current_frame/50));
	
	if !surface_exists(pause_surf){
		pause_surf = surface_create(game_width * 2, _hig);
	}
	if !surface_exists(pause_surf_2){
		pause_surf_2 = surface_create(game_width * 2, _hig);
	}
	surface_set_target(pause_surf);
		draw_clear_alpha(c_black, 0);
	
		for(var i = -game_width/_wid;i<game_width*2/_wid;i++){
			draw_sprite(_baker, 0, _xoff + (i * _wid), _hig / 2);
		}
		draw_set_alpha(_alpha);
		for(var i = -game_width/_wid;i<game_width*2/_wid;i++){
			draw_sprite(_bak, 0, _xoff + (i * _wid), _hig / 2);	
		}
		draw_set_alpha(1);
		for(var i = game_width/_wid; i > -game_width*2/_wid;i--){
			draw_sprite(_spr, 0, game_width-_xoff - _wid - (i * _wid), _hig / 2);		
		}
	surface_reset_target();
	
	surface_set_target(pause_surf_2);
		for(var i = -game_width*2/_wid;i<game_width*2/_wid;i++){
			draw_sprite(_baker, 0, (game_width-_xoff - _wid - (i * _wid)), _hig/2);
		}
		draw_set_alpha(_alpha);
		for(var i = -game_width*2/_wid;i<game_width*2/_wid;i++){
			draw_sprite(_bak, 0, (game_width-_xoff - _wid - (i * _wid)), _hig/2);
		}
		draw_set_alpha(1);
		for(var i = game_width*2/_wid; i > -game_width*2/_wid;i--){
			draw_sprite(_spr, 0, (_xoff + (i * _wid)), _hig/2);
		}
	surface_reset_target();
	
	
	gpu_set_blendenable(false);
	draw_surface_ext(pause_surf, -96, game_height / 2, 0.75, 0.75, 45, c_white, 1);
	draw_surface_ext(pause_surf, -16, -24, 1.025, 1.025, -2.5, c_white, 1);
	draw_surface_ext(pause_surf_2, - 16, game_height*2 - (_hig * 2) + 16, 2.25, 2.25, 3, c_white, 1);
	gpu_set_blendenable(true);
	
	display_set_gui_size(_dw, _dh);
}