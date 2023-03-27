
function audio_caption_init(){
	global.ClosedCaptioning = ds_list_create();
	#macro CAPTION global.ClosedCaptioning
	// Initialize all captions with sounds here
	audio_caption_add_ext(GoldSrcGib,false,"[GoldSrc Gib Sound]",300,undefined);
	audio_caption_add_ext(sndDevTest,false,"Welcome to Team Fortress 2\nAfter 9 years of development hopefully,\nit will have been worth the weight\n\nThanks and have fun.",300,0);
}
function audio_caption_add(_SID,_WaitForCaption,_Text){
	audio_caption_add_ext(_SID,_WaitForCaption,_Text,room_speed,undefined);	
}
function audio_caption_add_ext(_SID,_WaitForCaption,_Text,_Lifetime,_ForcedOrder){
	ds_list_add(CAPTION,
		[
			_SID,
			_Text,
			_WaitForCaption,
			_Lifetime,
			_ForcedOrder
		]
	);
}
function audio_caption_lookup(_SID){
	for(var i = 0;i<ds_list_size(CAPTION);i++){
		if CAPTION[|i][0] == _SID{
			return new Caption(
				CAPTION[|i][0],
				CAPTION[|i][1],
				CAPTION[|i][2],
				CAPTION[|i][3],
				CAPTION[|i][4]
			);
		}
	}
	return undefined;
}

function Caption(_SID,_Text,_WaitForCaption,_Lifetime,_ForcedOrder) constructor{
	sound = _SID;
	text = _Text;
	WaitForCaption = _WaitForCaption;
	lifetime = _Lifetime;
	forcedOrder = _ForcedOrder;
	
	gain = 1;
	pitch = 1;
	offset = 0;
	played_sound = false;
	
	x = 0;
	y = 0;
	x_goal = 0;
	y_goal = 0;
	alpha = 1;
	schedule(1,function(){
			if !(WaitForCaption){
				audio_play_sound(sound,1,0,gain,offset,pitch);
				played_sound = true;
			}
		}
	);
	step = function(){
		/*
		if !(WaitForCaption) && played_sound == false{
			audio_play_sound(sound,1,0,gain,offset,pitch);
			played_sound = true;
		}
		*/
		x = lerp(x,x_goal,1/3);
		y = lerp(y,y_goal,1/3);
		if played_sound == true{
			lifetime --;
			if lifetime <= 0{
				alpha -= 0.05;
			}
		}
	}
}

function audio_play_captioned(_SID){
	if !audio_exists(_SID) exit;
	if !instance_exists(sys_ClosedCaptioning){
		instance_create_depth(0,0,0,sys_ClosedCaptioning);	
	}
	var _lq = audio_caption_lookup(_SID);
	if !is_undefined(_lq){
		if is_struct(_lq){
			with(sys_ClosedCaptioning){
				ds_list_add(audio_queue,audio_caption_lookup(_SID));	
			}
			delete _lq;
		}
	}else{
		audio_play_sound(_SID,1,0);	
	}
}

function audio_play_captioned_pitch(_SID,_pitch){
	audio_play_captioned_pitchvol(_SID,_pitch,1);
}
function audio_play_captioned_pitchvol(_SID,_pitch,_vol){
	if !audio_exists(_SID) exit;
	if !instance_exists(sys_ClosedCaptioning){
		instance_create_depth(0,0,0,sys_ClosedCaptioning);	
	}
	var _lq = audio_caption_lookup(_SID);
	_lq.pitch = _pitch;
	_lq.gain = _vol;
	if !is_undefined(_lq){
		if is_struct(_lq){
			with(sys_ClosedCaptioning){
				ds_list_add(audio_queue,_lq);	
			}
		}
	}else{
		audio_play_sound(_SID,1,0,_vol,0,_pitch);	
	}
}

function sys_ClosedCaptioning_Create(){
	audio_queue = ds_list_create();
	caption_clear_timer = 0;
	caption_opacity = 0;	
}

function sys_ClosedCaptioning_Draw_Gui(){
	// Set the GUI size to match the Window size
	// I'm pretty sure this is necessary since we want it to appear at the middle of the window
	var _gwid = display_get_gui_width(),_ghig = display_get_gui_height();
	display_set_gui_size(window_get_width(),window_get_height());
	if !ds_exists(audio_queue,ds_type_list){
		audio_queue = ds_list_create();	
	}
	draw_set_font(fntM);
	draw_set_valign(fa_bottom);
	draw_set_halign(fa_left);
	draw_text(8,32,string_from_args("Caption Timer",caption_clear_timer));
	draw_set_halign(fa_center);
	x = window_get_width()/2;
	y = window_get_height() - string_height("A");
	
	//===========================
	// Draws the captioned text
	//===========================
	var _yoffset = 0; // Store this variable for later
	for(var i = 0;i<ds_list_size(audio_queue);i++){
		if !is_struct(audio_queue[|i]){
			// Cleans up erroneous entries
			ds_list_delete(audio_queue,i);
			i --;
		}else{
			var _a = 1;
			with(audio_queue[|i]){
				// Store these for later use
				var _xst = other.x + x, _yst = other.y + y;
				var _ap = draw_get_alpha();
				// Shift the text to the appropriate location based on other entries
				// The captions maintain both x_goal and y_goal. If you wanted to shift it horizontally instead, just change that latter.
				y_goal = _yoffset;
				// Shift the offset to shift future entries
				_yoffset += -string_height(text);
				
				// Runs the Step function declared in the Caption's struct
				step();
				
				// Draw a rectangle under the text
				draw_set_alpha(alpha * 0.66);
				draw_set_color(c_dkgray);
				draw_rectangle(_xst - string_width(text)/2, _yst, _xst + string_width(text)/2, _yst - string_height(text), 0);
				// Draw the text
				draw_set_alpha(alpha);
				draw_set_color(c_white);
				draw_text(_xst, _yst,text);
				// Reset the alpha
				draw_set_alpha(_ap);
				
				// Grab this for below to clean up the caption
				_a = alpha;
			}
			// Deletes the caption if it's fully faded out
			if _a <= 0{
				delete audio_queue[|i];
				i --;
			}
		}
		// Too many captions; Cut that shit out
		// One big one will be able to appear, but anything after that will not
		if (abs(_yoffset) > window_get_height() / 4)
			break;
	}
	// Reset the GUI size
	display_set_gui_size(_gwid,_ghig);
}