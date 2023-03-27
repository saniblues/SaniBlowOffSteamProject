/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
do_movement = function(_id){
	with(_id){
		y = lerp(y, view_object.y,0.25)
		x = lerp(x, other.x + ((other.bbox_right - other.bbox_left) / 2), 0.25);
		floor(x);	
	}
}