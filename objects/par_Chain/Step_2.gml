{
	pixel_collision();
	// This part doesn't need to be graceful
	var _xstart_prev = xstart_spd, _ystart_prev = ystart_spd;
	xstart = floor(xstart);
	ystart = floor(ystart);
	
	var _dir = point_direction(xstart,ystart,xstart + xstart_spd,ystart + ystart_spd);
	var _xst = xstart, _yst = ystart;
	var _spd = sqrt(power(xstart_spd,2) + power(ystart_spd,2));
	if abs(_spd){
		repeat(_spd){
			_xst += lengthdir_x(1,_dir);
			_yst += lengthdir_y(1,_dir);
			if collision_point(_xst,_yst,par_CollisionObject,1,0) != -4{
				xstart_spd = 0;
				ystart_spd = 0;
				break;	
			}
		}
		xstart = _xst;
		ystart = _yst;
		with(array_last(joint)){
			xprevious = _xst;
			yprevious = _yst;
			x = _xst;
			y = _yst;
		}
	}
	/*
	repeat(abs(xstart_spd)){
		xstart += sign(xstart_spd);
		if collision_point(xstart + sign(xstart_spd),ystart,par_CollisionObject,0,1){
			xstart += sign(xstart_spd);
			xstart_spd = 0;
			break;
		}
	}
	repeat(abs(ystart_spd)){
		ystart += sign(ystart_spd);
		if collision_point(xstart,ystart + sign(ystart_spd),par_CollisionObject,0,1){
			ystart += sign(ystart_spd);
			ystart_spd = 0;
			break;
		}
	}
	*/
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
		var _xp = x, _yp = y;
		x = xstart + lengthdir_x(rope_length,_dir);
		y = ystart + lengthdir_y(rope_length,_dir);
		if instance_exists(anchored){
			hspd -= diff(_xp,x);
			vspd -= diff(_yp,y);
			var __yp = y;
			y -= diff(x,_xp) * (x > xstart ? -1 : 1);
		}
	}
	hspd = hspd * 0.98;
	vspd = vspd * 0.98;
}