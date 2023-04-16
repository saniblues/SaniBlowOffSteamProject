/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

do_movement = function(_id){
	with(_id){
		var _x = other.x + ((other.bbox_right - other.bbox_left) / 2);
		x = lerp(x, _x,0.25);
		if absdiff(x,_x) <= CAM_LERP_MIN{
			x = _x;	
		}
		var _y = other.y + ((other.bbox_bottom - other.bbox_top) / 2);
		y = lerp(y, _y, 0.25);	
		if absdiff(y,_y) <= CAM_LERP_MIN{
			y = _y;	
		}
		floor(x);
		floor(y);
	}
}