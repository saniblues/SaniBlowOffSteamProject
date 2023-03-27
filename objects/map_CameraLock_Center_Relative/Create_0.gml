/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
do_movement = function(_id){
	with(_id){
		window_set_caption(string_from_args(object_get_name(object_index),":",object_get_name(other.object_index)));
		var _x = median(other.bbox_left + (game_width/2), view_object.x,other.bbox_right - (game_width/2));
		var _y = median(other.bbox_top + (game_height/2), view_object.y,other.bbox_bottom - (game_height/2));//x = lerp(x, other.x + ((other.bbox_right - other.bbox_left) / 2),0.25)
		_x = lerp(x,_x,0.25);
		_y = lerp(y,_y,0.25);
		
		other.resolve_movement(_x,_y);
	}
}