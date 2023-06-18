{
	debug_drag_step();
	// Update this live
	if keyboard_check(vk_up) rope_length = lerp(rope_length,joint_num,0.125);//max(joint_num,rope_length - 2);
	if keyboard_check(vk_down) rope_length = lerp(rope_length,128,0.125);//min(48,rope_length + 2);
	joint_distance = rope_length / joint_num;
	if array_length(joint) == 0 exit;
	if point_distance(x,y,xstart,ystart) > rope_length{
		var _dir = point_direction(xstart,ystart,x,y);
		x = xstart + lengthdir_x(rope_length,_dir);
		y = ystart + lengthdir_y(rope_length,_dir);
	}
	var _sspd = sqrt(power(xstart_spd,2) + power(ystart_spd,2));
	joint_iterations = 3 + min(20,(_sspd * 20));
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
		with(array_last(joint)){
			if instance_exists(other.anchor){
				x = other.anchor.x;
				y = other.anchor.y;
			}else{
				x = other.xstart;
				y = other.ystart;
			}
		}
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
		}
	}
	if instance_exists(anchored){
		anchored.x = x;
		anchored.y = y;
		if xstart_spd == 0 hspd += anchored.hspd / 16;
		if ystart_spd == 0 vspd += anchored.vspd / 16;
		if instance_is(anchored,Player){
			if button_pressed(0,KEY_UP) || button_pressed(0,KEY_JUMP){
				on_pick(anchored);
			}
		}
	}else{
		hspd += 0.07 * cos((rand + current_frame)/40);	
	}
	if button_pressed(0,KEY_PICK) && place_meeting(x,y,Player){
		on_pick(Player);
	}
	
	if button_pressed(0,KEY_SPEC){
		xstart = x + random_range(-1,1);
		ystart = y + random_range(-1,1);
		var _dir = point_direction(x,y,mouse_x,mouse_y);
		xstart_spd = lengthdir_x(12,_dir);
		ystart_spd = lengthdir_y(12,_dir);
	}
	vspd += GRAV_FACTOR;
}