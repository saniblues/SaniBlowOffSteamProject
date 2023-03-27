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
	
	if is_undefined(image_xscale_draw){
		draw_sprite_ext(sprite_index,image_index,ceil(x),ceil(y),image_xscale * image_scale, image_yscale * image_scale, round(image_angle_draw), image_blend, image_alpha);
	}else{
		draw_sprite_ext(sprite_index,image_index,ceil(x),ceil(y),image_xscale_draw * image_scale, image_yscale_draw * image_scale, round(image_angle_draw), image_blend, image_alpha);
	}
}