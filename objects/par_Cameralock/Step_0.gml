{
	var _r = false;
	with(obj_Camera){
		if view_anchor == other.id{
			_r = true;	
		}
	}
	if place_meeting(x,y,Player) || (_r){
		with(obj_Camera){
			var _view_current_priority = (instance_exists(view_anchor) ? view_anchor.view_anchor_priority : -1);
			if (view_anchor_timer <= 0 || view_anchor == other.id){
				view_anchor = other.id;
				other.do_movement(id);
				//script_execute(other.do_movement);
			}
		}
	}
}