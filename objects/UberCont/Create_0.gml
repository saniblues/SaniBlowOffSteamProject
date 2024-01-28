{
	sleep_frames = 0;
	sleep_delay = 0;
	
	typing = false;
	input_string = "";
	
	schedule_queue = ds_list_create();
	scrInit();
	
	with(instance_create(game_width/2, game_height/2, ExampleObject)){
		for(var i = 0;i<=20;i++){
			schedule_pass(30 + (i), function(_i){
				//trace("GOOD MORNING EVERYNYAN", current_frame);
				image_angle = (360/20) * _i;
			}, i);
		}
	}
	active_menus = [];
	current_menu = -4;
	menu_queue_prune = false;
	MenuItem = -1;
		
	uberpause = false;
	pauseSurf = -4;
	pauseSurfBuffer = -4;
	pause_list = ds_list_create();
}