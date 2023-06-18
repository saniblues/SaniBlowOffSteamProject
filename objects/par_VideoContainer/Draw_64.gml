{
	if !(VIDEO.fullscreen) exit; // Draws to GUI instead
	trace(video_alpha);
	var _x = 0, _y = 0;
	var _dw = display_get_gui_width(), _dh = display_get_gui_height();
	
	display_set_gui_size(window_get_width(), window_get_height());

	var _vid = video_draw();
	var _status = _vid[0];
	if (_status == 0){
		if !(video_finished){
			if video_alpha < 1{
				if video_get_position() > 100 && video_alpha < 0.5 video_pause();
				//VIDEO.pause = true;
				if !UBERPAUSE video_alpha = lerp(video_alpha, 1, 0.05);
				if video_alpha >= 0.5{
					//video_alpha = 1;
					if video_get_status() == video_status_paused video_resume();	
				}
			}
		}else{
			if video_alpha > 0{
				video_alpha = lerp(video_alpha, 0, 0.05);
				if video_alpha <= 0.05{
					display_set_gui_size(_dw,_dh);
					instance_destroy();
					exit;
				}
			}
		}
		var _output = _vid[1];
		var desired_width = window_get_width();
		var desired_height = window_get_height();
		
		// If we just want it to stretch to fit one or the other, we can just do one "_ratio"
		//    instead of two separate ratios (ie. stretch to width/stretch to height)
		var _ratio_w = (desired_width / surface_get_width(_vid[1]));
		var _ratio_h = (desired_height / surface_get_height(_vid[1]));
		
		
		if (UBERPAUSE || blur_intensity > 0){//(VIDEO.pause || blur_intensity > 0){
			blur_intensity = lerp(blur_intensity, blur_intensity_goal, 0.025);
			shader_draw_begin(shd_blur);
		}
		draw_surface_ext(_output,_x,_y,_ratio_w,_ratio_h,0,c_white,video_alpha);
		if (UBERPAUSE || blur_intensity > 0){//(VIDEO.pause || blur_intensity > 0){
			shader_draw_end(shd_blur);	
			blur_intensity = lerp(blur_intensity, blur_intensity_goal, 0.025);
		}
		if video_get_position() == 0 && (VIDEO.loaded) && !(video_finished){
			trace("Video's over! Byebye!");
			video_seek_to(video_get_duration());
			video_pause();
			VIDEO.pause = true;
			video_finished = true;
		}
		if video_get_position() > 0 VIDEO.loaded = true;
	}else{
		trace("ERROR! Try putting video in root...");
		display_set_gui_size(_dw,_dh);
		instance_destroy();
		exit;
	}
	/*
	if button_pressed(0,KEY_ESC) || button_pressed(0,KEY_SELECT){
		VIDEO.pause = !VIDEO.pause;
		if (VIDEO.pause){
			video_pause();
			blur_intensity_goal = 0.2;
		}else blur_intensity_goal = 0;
	}
	if !(VIDEO.pause){
		if blur_intensity <= 0.05{
			blur_intensity = 0;
			blur_intensity_goal = 0;
			video_resume();
		}
	}else{
		draw_set_valign(fa_center);
		draw_set_halign(fa_center);
		draw_set_alpha(blur_intensity * 5);
		draw_text(window_get_width()/2, window_get_height()/2, "[Pause]");
		draw_set_alpha(1);
	}
	*/
	display_set_gui_size(_dw,_dh);
}