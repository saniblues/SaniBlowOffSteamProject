function MenuObject_DoPivot(){
	// Pivot stuff goes here	
}
function MenuObject_CorrectPos(){
	// Just a debug toggle on position to test the below content
	if current_frame % 240 == 0{
		//x_goal = (x_goal == -8 ? 8 : -8);	
	}
	// Makes it adjust to desired position
	x = lerp(x,x_goal,0.25);
	y = lerp(y,y_goal,0.25);
}

function MenuObject(_x,_y) constructor{
	x = _x;
	y = _y;
	x_goal = x;
	y_goal = y;
	image_xscale = 1.5;
	image_yscale = 1;
	
	pivot_x = x;
	pivot_y = y;
	pivot_len = 0;
	pivot_dir = 0;
	pivot_progress = 1;
	pivot_progress_max = 1.10;
	
	pivot_phase = 0;
	
	sprite_idle = sprBasic9Slice;
	sprite_active = sprBasic9Slice_Cyan;
	sprite_draw_hitbox = true;
	sprite_index = mskNone;
	
	on_pick = function(){
		trace("HELLO EVERYNYAN",current_frame);	
	}
	on_step = undefined;
	on_draw = function(){
		var _spr = sprite_idle;
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
		// If the mouse is in the current element, draw the Active sprite instead,
		   // and perform on_pick(); when the mouse button is RELEASED
		   // (sorry for yelling, I was yelling at myself as I typed that)
		   // (please understand)
		if point_in_rectangle(_mx,_my, x - (image_xscale * 3), y - (image_yscale * 3),x + (image_xscale * 3), y + (image_yscale * 3)){
			_spr = sprite_active;
			if button_released(0,KEY_FIRE){
				on_pick();	
			}
		}
		MenuObject_CorrectPos();
		// Only draws the basic 9slice when this is set to True
		// Also note, that this is set to True by default
		if sprite_draw_hitbox == true{
			draw_sprite_ext(_spr,0,x,y,image_xscale,image_yscale,0,c_white,1);
		};
		// Draws the sprite
		// By default this is mskNone so it's effectively drawing nothing
		draw_sprite(sprite_index,current_frame % 0.20,x,y);
	}
	// This performs the on_draw event AFTER the standard draw event
	on_draw_post = undefined;
}

function ratio_get_from_value(value, minValue, maxValue){
	var _range = maxValue - minValue;
	// Calculate the distance between the given value and the minimum value.
	var distance = value - minValue;
	// Calculate the ratio of the distance to the range.
	var ratio = distance / _range;
	// Return the ratio.
	return ratio;
}
function MenuSlider(_x, _y, _type, _width, _height, _min, _max) constructor{
	x = _x;
	y = _y;
	button_x = x;
	button_y = y;
	width = _width * 3;
	height = _height * 3;
	type = _type; // 0 = Horizontal, 1 = Vertical
	val_min = _min;
	val_max = _max;
	val_live = 0;
	tracking = false;
	ratio = 0;
	dummy = 1;
	target = [self, "dummy"];
	target_resolved = false;
	
	x_goal = x;
	y_goal = y;
	image_xscale = 1;
	image_yscale = 1.5;
	
	pivot_x = x;
	pivot_y = y;
	pivot_len = 0;
	pivot_dir = 0;
	pivot_progress = 1;
	pivot_progress_max = 1.10;
	
	pivot_phase = 0;
	last_audio = 0;
	
	sprite_idle = sprBasic9Slice;
	sprite_active = sprBasic9Slice_Cyan;
	sprite_draw_hitbox = true;
	sprite_index = mskNone;
	
	on_step = undefined;
	on_draw = function(){
		var _val = variable_instance_get(target[0],target[1]);
		if is_undefined(_val){
			exit;
		}
		val_live = _val;
		ratio = ratio_get_from_value(val_live,val_min,val_max);
		trace(val_min,val_live,val_max);
		if (type == 0){
			button_x = clamp(x,x + (width * ratio),x+width);
			image_yscale = 1;
			image_xscale = 1.5;
		}else if (type == 1){
			image_yscale = 1.5;
			image_xscale = 1;
			button_y = clamp(y,y + (height * ratio),y+height);	
		}
		var _spr = sprite_idle;
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
		// If the mouse is in the current element, draw the Active sprite instead,
		   // and perform on_pick(); when the mouse button is RELEASED
		   // (sorry for yelling, I was yelling at myself as I typed that)
		   // (please understand)
		if point_in_rectangle(_mx,_my, button_x - (image_xscale * 3), button_y - (image_yscale * 3),button_x + (image_xscale * 3), button_y + (image_yscale * 3)){
			if button_pressed(0,KEY_FIRE){
				tracking = true;
			}
		}
		if (tracking){
			if !button_check(0, KEY_FIRE) tracking = false;
			_spr = sprite_active;
			var _oldx = button_x, _oldy = button_y;
			if type == 0{
				button_x = median(x, _mx, x + width);
				button_y = y;
				ratio = (button_x - x) / width;
				
				if button_x != _oldx && last_audio <= current_frame - 5{
					last_audio = current_frame;
					audio_stop_sound(Bounce);
					audio_play_sound(Bounce,0,0);
				}
			}else{
				button_x = x;
				button_y = median(y, _my, y + height);
				ratio = (button_y - y) / height;
				if button_y != _oldy && last_audio <= current_frame - 5{
					last_audio = current_frame;
					audio_stop_sound(Bounce);
					audio_play_sound(Bounce,0,0);
				}
			}
		}
		var _val = variable_instance_get(target[0],target[1]);
		if !is_undefined(_val){
			var _final = roundToNearestTenth((val_min + (diff(val_max,val_min) * ratio)));
			variable_instance_set(target[0], string(target[1]), _final);
		}
		MenuObject_CorrectPos();
		// Only draws the basic 9slice when this is set to True
		// Also note, that this is set to True by default
		if sprite_draw_hitbox == true{
			draw_set_color(c_white);
			//draw_rectangle(x,y-height/2,x+width,y+height/2,0);
			draw_sprite_ext(sprBasic9Slice,0,x-4+floor(width/2),y+floor(type == 0 ? 0 : height/2),width/sprite_get_width(sprBasic9Slice),height/sprite_get_height(sprBasic9Slice),0,c_white,1);
			draw_sprite_ext(_spr,0,button_x,button_y,image_xscale,image_yscale,0,c_white,1);
		};
		// Draws the sprite
		// By default this is mskNone so it's effectively drawing nothing
		draw_sprite(sprite_index,current_frame % 0.20,x,y);
	}
	// This performs the on_draw event AFTER the standard draw event
	on_draw_post = undefined;
}

function roundToNearestTenth(number)
{
    // Multiply the number by 10 to move the decimal point one place to the right.
    var multiplied = number * 20;
    
    // Round the multiplied number to the nearest integer.
    var rounded = round(multiplied);
    
    // Divide the rounded number by 10 to move the decimal point back to its original position.
    var result = rounded / 20;
    
    // Check if the difference between the result and the nearest whole number is less than 0.10.
    if (abs(result - round(result)) <= 0.05) {
        // If it is, round the result to the nearest whole number.
        result = round(result);
    }
	return result;
}

function MenuItem_Create(_x, _y){
	if !var_in_self("MenuItem"){
		MenuItem = ds_list_create();
	}
	var _MenuObject = new MenuObject(_x, _y);
	ds_list_add(MenuItem,_MenuObject);	
	return MenuItem[|ds_list_size(MenuItem) - 1];
}

function MenuSlider_Create(_x, _y, _width){
	MenuSlider_Create_Ext(_x, _y, 0, _width, 3, 0, 1);
}

function MenuSlider_Create_Ext(_x, _y, _type, _width, _height, _min, _max){
	if !var_in_self("MenuItem"){
		MenuItem = ds_list_create();
	}
	var _MenuObject = new MenuSlider(_x, _y, _type, _width, _height, _min, _max);
	ds_list_add(MenuItem, _MenuObject);
	return MenuItem[|ds_list_size(MenuItem) - 1];
}