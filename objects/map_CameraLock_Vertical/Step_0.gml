{
	if place_meeting(x,y,Player){
		with(obj_Camera){
			view_anchor = other.id;
			y = lerp(y, view_object.y,0.25)
			x = lerp(x, other.x + ((other.bbox_right - other.bbox_left) / 2), 0.25);
			floor(x);
		}
	}
}