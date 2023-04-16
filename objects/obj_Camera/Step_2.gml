{
	if !instance_exists(view_object){
		exit;	
	}				
	if !(cutscene){
		var _o = id, _r = false;
		with(view_object){
			if place_meeting(x,y,map_CameraLock_LookAt){
				var _id = -1;
				with(instance_nearest(x,y,map_CameraLock_LookAt)){
					_id = floor(image_index);
				}
				with(par_Cameralock){
					if view_anchor_id == _id{
						_r = true;
						_o.view_anchor = id;
						_o.view_anchor_timer = ceil(room_speed * 0.125);	
					}
				}
			}
		}
		var _vx = floor(view_object.x), _vy = floor(view_object.y);
		if !instance_exists(view_anchor){
			x = lerp(x, _vx, 0.5);
			y = lerp(y, _vy, 0.5);
			if absdiff(x,_vx) <= CAM_LERP_MIN{
				x = _vx;	
			}
			if absdiff(y,view_object.y) <= CAM_LERP_MIN{
				y = _vy;	
			}
		}else{
			with(view_object){
				if !(_r){
					if !place_meeting(x,y,other.view_anchor){
						if(other.view_anchor_timer && !--other.view_anchor_timer){
							other.view_anchor = -4;	
						}
					}else{
						other.view_anchor_timer = ceil(room_speed * 0.125);	
					}
				}
			}
		}
		if !instance_exists(zoom_object){
			cam_zoom_goal = 1;	
		}
		cam_zoom = lerp(cam_zoom, cam_zoom_goal, 0.25);
		if cam_zoom != 1{
			surface_resize(application_surface, game_width/cam_zoom_goal, game_height/cam_zoom_goal);	
		}
	}
	camera_set_view_size(view_camera[0], game_width / cam_zoom, game_height / cam_zoom);
	camera_set_view_pos(view_camera[0], floor(x) - floor((game_width/2) / cam_zoom), floor(y) - floor((game_height/2) / cam_zoom)); 
}