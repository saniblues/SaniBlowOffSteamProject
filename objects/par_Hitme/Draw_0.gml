{
	if is_undefined(has_on_draw){
		try{
			on_draw();
			has_on_draw = true;
		}catch(_error){
			has_on_draw = false;	
		}
	}else{
		if (has_on_draw){
			on_draw();	
		}
	}
	
	draw_sprite_ext(sprite_index,image_index,x,y,image_xscale * image_scale, image_yscale * image_scale, image_angle, image_blend, image_alpha);
}