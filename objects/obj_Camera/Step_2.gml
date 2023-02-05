{
	if !instance_exists(view_object){
		exit;	
	}
	if !(cutscene){
		if !instance_exists(view_anchor){
			x = lerp(x, view_object.x, 0.25);
			y = lerp(y, view_object.y, 0.25);
			x = floor(x);
			y = floor(y);
		}else{
			with(view_object){
				if !place_meeting(x,y,other.view_anchor){
					other.view_anchor = -4;	
				}
			}
		}
	}
	
	camera_set_view_pos(view_camera[0], floor(x - (game_width/2)), floor(y - (game_height/2))); 
}