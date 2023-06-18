{
	UBERPAUSE = false;
	VIDEO.pause = false;
	for(var i = 0;i<ds_list_size(pause_list);i++){
		instance_activate_object(pause_list[|i]);	
	}
	//instance_activate_all();
	if (surface_exists(pauseSurf)) surface_free(pauseSurf);
	if (buffer_exists(pauseSurfBuffer)) buffer_delete(pauseSurfBuffer);	
}