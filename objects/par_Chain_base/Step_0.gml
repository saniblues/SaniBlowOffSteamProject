{
	debug_drag_step();
	// Update this live
	joint_distance = rope_length / joint_num;
	if array_length(joint) == 0 exit;
	if point_distance(x,y,xstart,ystart) > rope_length{
		var _dir = point_direction(xstart,ystart,x,y);
		x = xstart + lengthdir_x(rope_length,_dir);
		y = ystart + lengthdir_y(rope_length,_dir);
	}
	repeat(joint_iterations){
		for(var i = 0;i<joint_num-1;i++){
			var _live = joint[i], _temp = joint[i + 1];
			var _len = point_distance(_live.x,_live.y,_temp.x,_temp.y);
			var _dir = point_direction(_live.x,_live.y,_temp.x,_temp.y);
			
			//_len *= joint_distance*joint_distance/(_len*_len+joint_distance*joint_distance)-0.5; // Clean this up holy shit what is this guy on
			_len *= joint_distance*joint_distance/(_len*_len+joint_distance*joint_distance)-0.5;
			_live.x -= lengthdir_x(_len, _dir);
			_temp.x += lengthdir_x(_len, _dir);
			_live.y -= lengthdir_y(_len, _dir);
			_temp.y += lengthdir_y(_len, _dir);
			
		}
		joint[0].x = x;
		joint[0].y = y;
		if instance_exists(anchored){
			anchored.x = x;
			anchored.y = y;
			hspd = anchored.hspd;
			vspd = anchored.vspd;
			if instance_is(anchored,Player){
				if button_pressed(0,KEY_UP){
					anchored.vspd = -4;
					anchored.moveState = movestate.jump;
					anchored = -4;
				}
			}
		}
		with(array_last(joint)){
			if instance_exists(other.anchor){
				x = other.anchor.x;
				y = other.anchor.y;
			}else{
				x = other.xstart;
				y = other.ystart;
			}
		}
		/*
		for(var i = 0;i<joint_num;i++){
			with(joint[i]){
				var _xvel = x - xprevious, _yvel = y - yprevious;
				if position_meeting(x + _xvel,y,par_CollisionObject){
					x = xprevious;
				}
				if position_meeting(x, y + _yvel, par_CollisionObject){
					y = yprevious;
				}
			}
		}*/
	}
}