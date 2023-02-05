{
	try{
		on_step();
		has_on_step = true;
	}catch(_error){
		has_on_step = false;
		//show_message("on_step FAILED TO COMPILE!");
	}
}