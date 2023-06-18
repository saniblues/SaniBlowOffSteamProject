{
	pixel_collision();
	if array_length(joint) > 1{
		for(var i = 1;i<joint_num-1;i++){
			var _prev = joint[i - 1], _live = joint[i], _temp = joint[i + 1];
			var _len = point_distance(_live.x,_live.y,_temp.x,_temp.y);
			var _dir = point_direction(_live.x,_live.y,_temp.x,_temp.y);
			
			var _dir1 = point_direction(_live.x,_live.y,_prev.x,_prev.y);
			var _dir2 = point_direction(_live.x,_live.y,_temp.x,_temp.y);
			
			/*
			I get the thought process here, but I need to make it so that it re-calculates
			if the angle difference is too big or small. This is something that needs to happen
			in the Step event
			if angle_difference(_dir1, _dir2) >= joint_constraint{
				_live.x = _live.xprevious;
				_live.y = _live.yprevious;
			}
			*/
		}
	}
	for(var i = 0;i<joint_num;i++){
		with(joint[i]){
			//x += (x - xprevious);
			//y += (y - yprevious) + other.gravity_strength;
			xprevious = x;
			yprevious = y;
		}
	}
	if point_distance(x,y,xstart,ystart) > rope_length{
		var _dir = point_direction(xstart,ystart,x,y);
		x = xstart + lengthdir_x(rope_length,_dir);
		y = ystart + lengthdir_y(rope_length,_dir);
	}
	hspd = hspd * 0.98;
	vspd = vspd * 0.98;
}