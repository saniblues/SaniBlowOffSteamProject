{
	if keyboard_check_pressed(vk_home){
		image_index ++;
		image_index = floor(image_index % 5);
	}
	image_speed = 0;
	var zoom = (1/3) * 5;
	switch(floor(image_index)){
		case 1:
			zoom = 1/3;
			break;
		case 2:
			zoom = 1/6;
			break;
		case 3:
			zoom = 1/9;
			break;
	}
	if place_meeting(x,y,Player){
		with(obj_Camera){
			cam_zoom_goal = zoom;
			zoom_object = other.id;
		}
	}else{
		with(obj_Camera){
			if zoom_object = other.id{
				zoom_object = -4;
			}
		}
	}
}