{
	pauseSurf = -1;
	pauseSurfBuffer = -1;
	pause_list = ds_list_create();
	UBERPAUSE = true;
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
}