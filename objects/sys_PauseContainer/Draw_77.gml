{
	/*
	if keyboard_check_pressed(ord("P")){
		instance_destroy();
		exit;
	}
	*/
	/*
	{
		// Note: This is based on Spalding's tutorial but it has the clear issue
		// where it doesn't store what it does and doesn't activate/deactivate
		// Activated/Deactivated instances should be children of par_GameObject and
		// stored in a ds_list in the future. Functionality comes first.
		// 
		// Generally speaking, this should also go into its own function so that 
		// I can handle other stuff like pausing videos and whatnot (this was written
		// while muy_loco_commercial.avi was playing)
		UBERPAUSE = !UBERPAUSE;	
		if (UBERPAUSE){
			with(GameObject){
				ds_list_add(other.pause_list, id);
				instance_deactivate_object(id);
			}
			VIDEO.pause = true;
			//instance_deactivate_all(true);
			if (surface_exists(pauseSurf)) surface_free(pauseSurf);
			pauseSurf = surface_create(game_width,game_height);
			surface_copy(pauseSurf,0,0,application_surface);
			if (buffer_exists(pauseSurfBuffer)) buffer_delete(pauseSurfBuffer);
			pauseSurfBuffer = buffer_create(game_width * game_height * 4, buffer_fixed, 1);
			buffer_get_surface(pauseSurfBuffer, pauseSurf, 0);
		}else{
			VIDEO.pause = false;
			for(var i = 0;i<ds_list_size(pause_list);i++){
				instance_activate_object(pause_list[|i]);	
			}
			//instance_activate_all();
			if (surface_exists(pauseSurf)) surface_free(pauseSurf);
			if (buffer_exists(pauseSurfBuffer)) buffer_delete(pauseSurfBuffer);
		}
	}
	*/
	
	if (UBERPAUSE){
		surface_set_target(application_surface);
			if !surface_exists(pauseSurf){
				pauseSurf = surface_create(game_width,game_height);
				buffer_set_surface(pauseSurfBuffer, pauseSurf, 0);
			}
			draw_surface_blurred(pauseSurf, 0, 0);
			
			draw_set_alpha(0.5);
			draw_set_color(c_dkgray);
			draw_set_valign(fa_center);
			draw_set_halign(fa_center);
			draw_set_font(fntChat);
			draw_rectangle(0,0,game_width,game_height,0);
			draw_set_alpha(1);
			draw_set_color(c_white);
			draw_text(game_width/2,game_height/2,"[Pause]");
		surface_reset_target();
	}
	if !(menu_exists()) instance_destroy();
}