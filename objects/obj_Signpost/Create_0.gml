{
	depth += 99;
	active = false;
	dialogue_key = "HelloWorld";
	on_pick = undefined;
	schedule(1, function(){
		with(instance_create(x,y,par_Prompt)){
			creator = other;
			dialogue_key = other.dialogue_key;
			if is_undefined(other.on_pick){
				on_pick = function(){
					input_level_pause(0);
					audio_play_captioned(sndDevTest);
					//audio_play_sound(sndDevTest,1,0);
					say(dialogue_key);
					schedule(room_speed, function(){
							//trace("HELLO WORLD!");
							input_level_resume(0);
							active = false;
						}
					);
				}
			}else{
				on_pick = other.on_pick;
			}
		}
	}
	);
}