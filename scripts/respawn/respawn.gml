// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function respawn_self(_timer){
	with(instance_create(xstart,ystart,CustomObject)){
		payload = other.object_index;
		xstart = other.xstart;
		ystart = other.ystart;
		trace("respawn_selfING IN",_timer,"...");
		schedule(_timer, function(){
				trace("SPAWNING",object_get_name(payload));
				instance_create(xstart,ystart,payload);
				instance_destroy();
				exit;
			}
		);
	}
}