//Freeze frames
if(sleep_frames && !sleep_delay--){
	var _ct = current_time;
	while current_time < _ct + (sleep_frames * 16.67){
		//	
	}
	trace((current_time - _ct) / 1000)
	sleep_frames = 0;
}