function scrInit(){
	
	button_init();
	trace_init();
	dialogue_init();
	
	surface_resize(application_surface, game_width, game_height);
	display_set_gui_size((game_width * 2) + 1, (game_height * 2) + 1);
	#macro game_width 427
	#macro game_height 240
}