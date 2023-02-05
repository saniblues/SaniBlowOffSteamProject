{
	if is_undefined(has_on_step){
		try{
			on_step();
			has_on_step = true;
		}catch(_error){
			has_on_step = false;	
		}
	}else{
		if (has_on_step){
			on_step();	
		}
	}
}