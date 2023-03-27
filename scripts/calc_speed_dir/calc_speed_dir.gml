function set_speed_dir(_spd,_dir){
	hspd = lengthdir_x(_spd,_dir);
	vspd = lengthdir_y(_spd,_dir);
	hspd= cos(degtorad(_dir))*_spd;
	vspd=-sin(degtorad(_dir))*_spd;
}

function calc_speed_dir(_dir){
	return calc_speed_dir_ext(_dir, 1);
}
function calc_speed_dir_ext(_dir,_multi){
	/*
	If you set hspeed and vspeed to some number, the variable speed would give you the "partial" speed.
		So for example let's say you set hspeed and vspeed to 2. In this case you will move diagonally down 
		right (315 degrees). The built-in variable speed will be automatically changed to 2.828, as well as
		the built-in variable direction to 315. So if you want to calculate the variable speed you can do 
		so with sqrt(power(hspeed,2)+power(vspeed,2)) = sqrt( 22 + 22 ) = sqrt(8) = 2.828.
		So by changing these variables, the others automatically set themselves to the correct value.	
	*/
	if !var_in_self("hspd"){
		hspd = 0;
		vspd = 0;
		hspd_extra = 0;
		vspd_extra = 0;
		hspd_sub = 0;
		vspd_sub = 0;
	}
	
	// I think this works?
	var _spd = sqrt(power(hspd * _multi,2) + power(vspd * _multi,2));
	hspd = lengthdir_x(_spd,_dir);
	vspd = lengthdir_y(_spd,_dir);
	if (abs(vspd) <= 0.1){
		hspd = _spd * sign(hspd);
	}else if (abs(hspd) <= 0.1){
		vspd = _spd * sign(vspd);
	}
	speed_extra_compensate();
	
	return sqrt(power(hspd,2) + power(vspd,2));
}
function speed_extra_compensate(){
	if (abs(hspd) > max_hspd + hspd_extra){
		hspd_extra += absdiff(abs(hspd),max_hspd + hspd_extra);
	}
	if (abs(vspd) > max_vspd + vspd_extra){	
		vspd_extra += absdiff(abs(vspd),max_vspd + vspd_extra);
	}	
}
function crunch_speed(){
	var _dir = point_direction(x,y,x+hspd,y+vspd);
	var _spd = sqrt(power(hspd,2) + power(vspd,2));
	hspd = lengthdir_x(_spd,_dir);
	vspd = lengthdir_y(_spd,_dir);	
}