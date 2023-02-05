{
	if place_meeting(x,y,Player){
		with(obj_Camera){
			view_anchor = other.id;
			x = lerp(x, view_object.x,0.25)
			y = lerp(y, other.y + ((other.bbox_bottom - other.bbox_top) / 2), 0.25);
			floor(y);
		}
	}
}