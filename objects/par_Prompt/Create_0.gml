{
	depth -= 100;
	active = false;
	creator = -4;
	has_on_pick = undefined;
	on_pick = function(){
		audio_play_sound(sndDevTest,1,0);
		schedule(30,function(){
			active = false;
			}
		);
	}
}