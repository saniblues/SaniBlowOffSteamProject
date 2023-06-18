function scrInit(){
	
	trace_init();
	button_init();
	audio_caption_init();
	video_playback_init();
	dialogue_init();
	save_init();
	LoadGame("save0.dat");
	
	item_margin_init();
	
	surface_resize(application_surface, game_width, game_height);
	display_set_gui_size((game_width * 2) + 1, (game_height * 2) + 1);
	#macro game_width 427
	#macro game_height 240
	#macro CAM_LERP_MIN 8
	#macro view_xview camera_get_view_x(view_camera[0])
	#macro view_yview camera_get_view_y(view_camera[0])
	#macro UBERPAUSE UberCont.uberpause
	audio_group_set_gain(audiogroup_default, 1.5, 0);
	
	enum Schedule{
		ID,
		Timer,
		Function
	}
}