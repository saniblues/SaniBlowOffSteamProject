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
	// For the Player specifically, creates an object that buffers the damage by 14 : 60 frames
	// This way, you can jump out of the damage in order to negate the damage
	// 
	// I want to set this up so that Slimes can always be parried to no consequence, while hard 
	//   damage sources can reduce the damage to 1. Heavy damage sources should not be parry-able,
	//   and for the most part I'd reserve this to explosives
	with(_id){
		if instance_is(id,Player){
			if !instance_exists(damage_buffer){
				damage_buffer = instance_create(0,0,DamageBuffer);
				damage_buffer.fields = [_id, _damage, _use_iframes, _kb_str, _kb_dir];
				damage_buffer.buffer_frame = current_frame + 5;
				return true;
			}else{
				if damage_buffer.buffer_frame > current_frame{
					damage_buffer.fields[1] += _damage;
					damage_buffer.buffer_frame += 3;
					return true;
				}
			}
		}
	}
	with(_id){
		// Exit if the projectile adheres to iframes and cannot hit
		if nexthurt > current_frame && (_use_iframes){
			return false;
		}
		my_health -= _damage;
		nexthurt = current_frame + 5;
		//*/
		moveState = movestate.bonk;
		my_health += _damage;
		//*/
		if !is_undefined(_kb_str) && !is_undefined(_kb_dir){
			motion_add(_kb_dir,_kb_str);
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
		if instance_is(id,Player){
			damage_buffer = -4;	
		}
		return true;
	}
}