// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function projectile_hit(){
	// Default variables
	var _args = [id,0,false,undefined,undefined];
	// Apply given arguments over defaults
	for(var i = 0;i<argument_count;i++){
		_args[@i] = argument[i];	
	}
	// Run verbose script
	projectile_hit_ext(_args[0],_args[1],_args[2],_args[3],_args[4]);
}

function projectile_hit_ext(_id,_damage,_use_iframes,_kb_str,_kb_dir){
	// projectile_hit_ext(id,damage,use_iframes,knockback_strength,knockback_direction)
	// return: bool
	// If the damage resolves, returns true. Otherwise returns false.
	
	// Sanity checks
	if !instance_exists(_id) return false;
	if !variable_instance_exists(_id,"my_health") return false;
	
	with(_id){
		// Exit if the projectile adheres to iframes and cannot hit
		if nexthurt > current_frame && (_use_iframes){
			return false;
		}
		my_health -= _damage;
		nexthurt = current_frame + 5;
		if !is_undefined(_kb_str) && !is_undefined(_kb_dir){
			motion_add(_kb_str,_kb_dir);
		}
		// Runs an additional script, if defined
		if (has_on_hit){
			on_hit();
		}
		if my_health <= 0 && (candie){
			try{
				on_destroy();	
			}catch(_error){
				//	
			}
			instance_destroy();
		}
		return true;
	}
}