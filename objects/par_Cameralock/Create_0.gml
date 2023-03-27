{
	view_anchor_priority = 0;
	view_anchor_id = 0;
	image_speed = 0;
	schedule(1, function(){
			view_anchor_id = floor(image_index);
			visible = false;
		}
	);
	do_movement = function(){
		
	}
	
	resolve_movement = function(_x,_y){
		with(obj_Camera){
			var _wid = game_width/2, _hig = game_height/2;
			var _view_xview = camera_get_view_x(view_camera[0]), _view_yview = camera_get_view_y(view_camera[0]);
			var _inst = collision_line(_view_xview,y,_view_xview+_wid,y,map_CameraLock_NoGood_Hori,0,1);
			var _xp = x, _yp = y;
			if !instance_exists(_inst){
				x = _x;	
			}else{
				// Checks to see if you're moving away from the view block,
				// OR if the view object is on the opposite end of the view block (so the view isn't strictly locked)
				if (point_direction(x,y,bbox_hmid(_inst),y) != point_direction(x,y,_x,y)) || (sign(diff(view_object.x,bbox_hmid(_inst))) != sign(diff(x,bbox_hmid(_inst)))){
					x = _x;	
				}
			}
			_inst = collision_line(x,_view_yview,x,_view_yview + _hig,map_CameraLock_NoGood_Vert,0,1);
			if !instance_exists(_inst){
				y = _y;
			}else{
				// Does the same as above, but for Y
				if (point_direction(x,y,x,bbox_vmid(_inst)) != point_direction(x,y,x,_y)) || (sign(diff(view_object.y,bbox_vmid(_inst))) != sign(diff(y,bbox_vmid(_inst)))){
					y = _y;	
				}
			}
			/*
			if (absdiff(_xp,x)) > game_width{
				var _dist = median(-game_width,diff(_xp,x),game_width)
				x = _xp + _dist;
			}
			if (absdiff(_yp,y)) > game_height/2{
				var _dist = median(-game_height,diff(_yp,y),game_height)
				y = _yp + _dist;
			}
			*/
		}
	}
}