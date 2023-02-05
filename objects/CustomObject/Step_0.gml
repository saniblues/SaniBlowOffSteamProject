{
	//if created_frame < current_frame
	if !is_undefined(has_on_step){
		if (has_on_step){
			on_step();	
		}
	}
}