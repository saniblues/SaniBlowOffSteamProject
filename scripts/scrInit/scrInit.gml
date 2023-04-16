function scrInit(){
	
	button_init();
	trace_init();
	audio_caption_init();
	dialogue_init();
	save_init();
	LoadGame();
	
	surface_resize(application_surface, game_width, game_height);
	display_set_gui_size((game_width * 2) + 1, (game_height * 2) + 1);
	#macro game_width 427
	#macro game_height 240
	#macro CAM_LERP_MIN 8
	audio_group_set_gain(audiogroup_default, 1.5, 0);
}