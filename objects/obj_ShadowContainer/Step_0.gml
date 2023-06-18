{
	if !layer_exists(target_layer){
		trace("TARGET LAYER DOES NOT EXIST! Destroying...");
		instance_destroy();
		exit;
	}
	
	layer_set_visible(target_layer,false);
}