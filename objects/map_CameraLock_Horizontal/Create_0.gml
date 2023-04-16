/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
do_movement = function(_id){
	with(_id){
		var _y = other.y + ((other.bbox_bottom - other.bbox_top) / 2);
		x = lerp(x, view_object.x,0.25);
		y = lerp(y, _y, 0.25);
		if absdiff(y, _y) < CAM_LERP_MIN{
			y = _y;	
		}
		floor(y);
	}
}