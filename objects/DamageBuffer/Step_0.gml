{
	if !instance_exists(fields[0]){
		instance_destroy();
		exit;
	}
	with(fields[0]){
		if button_pressed(0,KEY_UP) && batch_compare(moveState, movestate.idle,movestate.walk,movestate.jump,movestate.doublejump) && instance_is(id,Player){
			moveState = movestate.doublejump;
			vspd = -4;
			nexthurt = current_frame + 5;
			with(instance_create(x,y,par_Effect)){
				sprite_index = spr_NuclearThroneImpactWrists;	
			}
			audio_play_captioned(sndPing);
			audio_stop_sound(snd_jump_start_new);
			with(other){
				instance_destroy();
				exit;
			}
		}
	}
	if buffer_frame <= current_frame{
		projectile_hit_ext(fields[0], fields[1], fields[2], 5, 135);
		instance_destroy();
		exit;
	}
}