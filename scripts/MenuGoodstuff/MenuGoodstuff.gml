enum menutype{
	button   = 0,
	slider   = 1,
	dropdown = 2,
	dropdown_override = 3
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
function menu_find(_ID){
	// Scans menus for the menu in question
	// If it does not exist, returns -4 (noone)
	with(UberCont){
		for(var i = 0;i<array_length(active_menus);i++){
			if active_menus[i] == _ID{
				return active_menus[i];	
			}
		}
	}
	return -4;
}
function menu_exists(){
	return array_length(UberCont.active_menus) > 0;	
}
function menu_set(_ID){
	with(UberCont){
		var _r = 0;
		// Scan for another instance of that menu
		for(var i = 0;i<array_length(active_menus);i++){
			if instance_exists(active_menus[i]){
				if active_menus[i].object_index == _ID{
					// Delete that index, and push the found menu to the front of the stack
					active_menus[i].active = true;
					array_push(active_menus,active_menus[i]);
					array_delete(active_menus,i,0);
					trace("PUSHING",object_get_name(_ID.object_index),"TO FRONT OF STACK");
					_r = 1;
					break;
				}
			}else{
				array_delete(active_menus, i, 1);
				i --;
			}
		}
		
		// Instance doesn't exist; Make a new one, then push it
		if !(_r){
			trace("MENU OBJECT NOT FOUND! Creating...");
			_ID = instance_create(0,0,_ID);
			array_push(active_menus, _ID);	
		}
	}
}
function menu_cleanup(){
	with(UberCont){
		var _count = 0;
		for(var i = 0;i<array_length(active_menus);i++){
			if !instance_exists(active_menus[i]){
				array_delete(active_menus,i,1);
				i --;
				_count ++;
			}
		}
		trace("PRUNED",_count,"BAD INDEXES!");
	}
}
function menu_get(){
	with(UberCont){
		return array_last(active_menus);//array_length(active_menus) > 0;
	}
}
function menu_prune(){
	with(UberCont){
		with(array_last(active_menus)){
			// Here I want to Deactivate the menus instead of destroying them, 
			// But that polish can come later. Functionality comes first.
			active = false;
		}
		array_delete(active_menus, array_length(active_menus) - 1, 1);
		//array_push(inactive_menus, array_pop(active_menus));
	}
	with(par_MenuObject){
		create_frame = current_frame;	
	}
}
/// Related to the actual handling of menus itself
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
	if absdiff(x,x_goal) <= 1{
		x = x_goal;	
	}
	y = lerp(y,y_goal,0.25);
	if absdiff(y,y_goal) <= 1{
		y = y_goal;	
	}
}
// MenuObject Creation+Handlers

function MenuObject(_x,_y,_displayName) constructor{
	x = _x;
	y = _y;
	xstart = _x;
	ystart = _y;
	x_goal = x;
	y_goal = y;
	x_goal_start = x_goal;
	y_goal_start = y_goal;
	xygoal_updated = false;
	schedule(1,function(){
		x_goal_start = x_goal;
		y_goal_start = y_goal;
		xygoal_updated = true;
		}
	);
	display_name = _displayName;
	image_xscale = 1.5;
	image_yscale = 1;
	
	bbox_left = x;
	bbox_top = y;
	bbox_right = x;
	bbox_bottom = y;
	
	pivot_x = x;
	pivot_y = y;
	pivot_len = 0;
	pivot_dir = 0;
	pivot_progress = 1;
	pivot_progress_max = 1.10;
	
	pivot_phase = 0;
	
	sprite_idle = sprBasic9Slice_TopLeft;
	sprite_active = sprBasic9Slice_Cyan_TopLeft;
	sprite_draw_hitbox = true;
	sprite_index = mskNone;
	creator = -4;
	active = true;
	cleanup = false;
	
	on_pick = function(){
		trace("HELLO EVERYNYAN",current_frame);	
	}
	on_pick_post = function(){
			
	}
	on_step = undefined;
	on_draw = function(){
		var _spr = sprite_idle;
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
		if instance_exists(creator) && (xygoal_updated) && !is_lq(creator){
			if variable_instance_exists(creator,"active"){
				active = creator.active;
				if menu_get() != creator{
					x_goal = -x_goal_start;
					y_goal = -y_goal_start;
				}else{
					x_goal = x_goal_start;
					y_goal = y_goal_start;
				}
			}
		}
		draw_set_font(fntChat);
		image_xscale = string_width(display_name) / (sprite_get_width(_spr));
		image_yscale = string_height(display_name) / (sprite_get_height(_spr));
		
		bbox_left = x;
		bbox_right = x + sprite_get_width(_spr) * image_xscale;
		bbox_top = y;
		bbox_bottom = y + sprite_get_height(_spr) * image_yscale;
		
		if !(active){
			x_goal = xstart;
			y_goal = ystart;
			if x == x_goal && y = y_goal || point_distance(x,y,x_goal,y_goal) <= 2{
				cleanup = true;
			}
		}
		// If the mouse is in the current element, draw the Active sprite instead,
		   // and perform on_pick(); when the mouse button is RELEASED
		   // (sorry for yelling, I was yelling at myself as I typed that)
		   // (please understand)
		if !(cleanup) && (active) && point_in_rectangle(_mx,_my, bbox_left,bbox_top,bbox_right,bbox_bottom){
			_spr = sprite_active;
			if button_released(0,KEY_FIRE){
				on_pick();
				on_pick_post();
			}
		}
		MenuObject_CorrectPos();
		// Only draws the basic 9slice when this is set to True
		// Also note, that this is set to True by default
		if sprite_draw_hitbox == true{
			draw_sprite_ext(_spr,0,x,y,image_xscale,image_yscale,0,c_white,1);
			// Draw Text for button
			draw_set_font(fntChat);
			draw_set_valign(fa_center);
			draw_set_halign(fa_center); //fa_left);
			draw_set_color(c_white);
			var __scale = 0.90; // 0.80;
			draw_text_transformed(bbox_left + floor((bbox_right - bbox_left) / 2),bbox_top + ceil((bbox_bottom - bbox_top)/2),display_name, __scale, __scale, 0);
		};
		// Draws the sprite
		// By default this is mskNone so it's effectively drawing nothing
		draw_sprite(sprite_index,current_frame % 0.20,x,y);
	}
	// This performs the on_draw event AFTER the standard draw event
	on_draw_post = undefined;
}
function MenuSlider(_x, _y, _displayName, _type, _width, _height, _min, _max) constructor{
	x = _x;
	y = _y;
	xstart = x;
	ystart = y;
	button_x = x;
	button_y = y;
	width = _width * 3;
	height = _height * 3;
	display_name = _displayName;
	display_text = "";
	type = _type; // 0 = Horizontal, 1 = Vertical
	val_min = _min;
	val_max = _max;
	val_live = 0;
	tracking = false;
	ratio = 0;
	dummy = 1;
	target = [self, "dummy"];
	target_resolved = false;
	creator = -4;
	active = true;
	cleanup = false;
	
	x_goal = x;
	y_goal = y;
	x_goal_start = x_goal;
	y_goal_start = y_goal;
	xygoal_updated = false;
	schedule(1,function(){
		x_goal_start = x_goal;
		y_goal_start = y_goal;
		xygoal_updated = true;
		}
	);
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
		// Checks for creator active variable first
		if instance_exists(creator){
			if variable_instance_exists(creator,"active"){
				active = creator.active;
				if menu_get() != creator && (xygoal_updated){
					x_goal = -x_goal_start;
					y_goal = -y_goal_start;
				}else{
					x_goal = x_goal_start;
					y_goal = y_goal_start;
				}
			}
		}
		// Grabs the variable from the target -- if it can't be found, it deactivates
		var _val = variable_instance_get(target[0],target[1]);
		if is_undefined(_val){
			trace("CANNOT FIND VARIABLE! Cleaning up...");
			active = false;
			cleanup = true;
			_val = 0;
		}
		if !(active){
			x_goal = xstart;
			y_goal = ystart;
			if x == x_goal && y = y_goal{
				cleanup = true;
			}
		}
		
		if (active){
			val_live = _val;
			ratio = ratio_get_from_value(val_live,val_min,val_max);
		}
		
		if (type == 0){
			button_x = clamp(x,x + (width * ratio),x+width);
			button_y = y;
			image_yscale = 1;
			image_xscale = 1.5;
		}else if (type == 1){
			image_yscale = 1.5;
			image_xscale = 1;
			button_x = x;
			button_y = clamp(y,y + (height * ratio),y+height);	
		}
		var _spr = sprite_idle;
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
		// If the mouse is in the current element, draw the Active sprite instead,
		   // and perform on_pick(); when the mouse button is RELEASED
		   // (sorry for yelling, I was yelling at myself as I typed that)
		   // (please understand)
		if (active) && point_in_rectangle(_mx,_my, button_x - (image_xscale * 3), button_y - (image_yscale * 3),button_x + (image_xscale * 3), button_y + (image_yscale * 3)){
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
		if (active){
			var _val = variable_instance_get(target[0],target[1]);
			if !is_undefined(_val){
				var _final = roundToNearestTenth((val_min + (diff(val_max,val_min) * ratio)));
				if is_lq(target[0]){
					lq_set(target[0],string(target[1]),_final);
				}else{
					variable_instance_set(target[0], string(target[1]), _final);
				}
			}
		}
		MenuObject_CorrectPos();
		// Only draws the basic 9slice when this is set to True
		// Also note, that this is set to True by default
		if sprite_draw_hitbox == true{
			draw_set_color(c_white);
			var _wextra = (type == 0 ? sprite_get_width(sprBasic9Slice) : 0) * image_xscale;
			var _hextra = (type == 1 ? sprite_get_height(sprBasic9Slice) : 0) * image_yscale;
			draw_sprite_ext(sprBasic9Slice_Back, 0, floor(x - sprite_get_width(sprBasic9Slice)/2), floor(y - sprite_get_height(sprBasic9Slice)/2), ((width + _wextra) / 9), ((height + _hextra) / 9), 0, c_white, 1);
			draw_sprite_ext(_spr,0,floor(button_x + (type == 0)),floor(button_y - (type == 0) + (type == 1)),image_xscale,image_yscale,0,c_white,1);
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
function MenuItem_Create(_x, _y, _displayName){
	if !var_in_self("MenuItem"){
		MenuItem = ds_list_create();
	}
	if !ds_exists(MenuItem,ds_type_list){
		MenuItem = ds_list_create();	
	}
	var _MenuObject = new MenuObject(_x, _y, _displayName);
	_MenuObject.creator = id;
	ds_list_add(MenuItem,_MenuObject);	
	return MenuItem[|ds_list_size(MenuItem) - 1];
}
function MenuSlider_Create(_x, _y, _width){
	MenuSlider_Create_Ext(_x, _y, 0, _width, 3, 0, 1);
}
function MenuSlider_Create_Ext(_x, _y, _displayName, _type, _width, _height, _min, _max){
	if !var_in_self("MenuItem"){
		MenuItem = ds_list_create();
	}
	if !ds_exists(MenuItem,ds_type_list){
		MenuItem = ds_list_create();	
	}
	var _MenuObject = new MenuSlider(_x, _y, _displayName, _type, _width, _height, _min, _max);
	_MenuObject.creator = id;
	ds_list_add(MenuItem, _MenuObject);
	return MenuItem[|ds_list_size(MenuItem) - 1];
}

function MenuObject_DropDown(_x,_y,_displayName) constructor{
	x = _x;
	y = _y;
	xstart = _x;
	ystart = _y;
	x_goal = x;
	y_goal = y;
	x_goal_start = x_goal;
	y_goal_start = y_goal;
	xygoal_updated = false;
	schedule(1,function(){
		x_goal_start = x_goal;
		y_goal_start = y_goal;
		xygoal_updated = true;
		}
	);
	display_name = _displayName;
	image_xscale = 1;
	image_yscale = 1;
	
	bbox_left = x;
	bbox_right = x;
	bbox_top = y;
	bbox_bottom = y;
	dropdown_startpos_type = 0;
	
	pivot_x = x;
	pivot_y = y;
	pivot_len = 0;
	pivot_dir = 0;
	pivot_progress = 1;
	pivot_progress_max = 1.10;
	
	pivot_phase = 0;
	
	sprite_idle = sprBasic9Slice_TopLeft;
	sprite_active = sprBasic9Slice_Cyan_TopLeft;
	sprite_draw_hitbox = true;
	sprite_index = mskNone;
	creator = -4;
	active = true;
	cleanup = false;
	menu_array = [];
	menu_active = [];
	menu_add = function(_type, _display_name, _function){
		menu_add_ext(_type, _display_name, _function);
	}
	menu_add_ext = function(){
		var arg = [menutype.button, "", function(){trace("Default Button")}, 0, 0, 0, 0, 0, 0, 0];
		for(var i = 0;i<argument_count;i++){
			arg[@i] = argument[i];
		}
		array_push(menu_array, [arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[9]]);	
	}
	menu_close_subs = function(){
		/*
			// Simple version: Just clear the active menu items
			menu_active = [];
		/*/
			// Fancy version: Deactivate all of them, then clean them up
			var _bb = bbox_right;
			for(var i = 0;i<array_length(menu_active);i++){	
				if is_lq(menu_active[i]){
					with(menu_active[i]){
						active = false;
					}
				}
			}
		//*/
	}
	on_pick = function(){
		if array_length(menu_active) == 0{
			var _xst = x, _yst = bbox_bottom + 4;
			if dropdown_startpos_type == 1{
				_xst = bbox_right + 4;
				_yst = y;
			}
			for(var i = 0;i<array_length(menu_array);i++){	
				var _temp;
				switch(menu_array[i][0]){
					case menutype.button:
						_temp = new MenuObject(_xst, _yst, "")
						break;
					case menutype.slider:
						_temp = new MenuSlider(_xst, _yst, "",menu_array[i][3],menu_array[i][4],menu_array[i][5],menu_array[i][6],menu_array[i][7]);
						_temp.target = menu_array[i][2];
						break;
					case menutype.dropdown:
					case menutype.dropdown_override:
						_temp = new MenuObject_DropDown(_xst, _yst,"");
						for(var io = 0;io<array_length(menu_array[i][3]);io++){
							_temp.menu_array[@io] = menu_array[i][3][io];
							_temp.dropdown_startpos_type = 1;
						}
						break;
				}
				with(_temp){
					display_name = other.menu_array[i][1];
					submenu_creator = other;
					if other.menu_array[i][0] == menutype.button || other.menu_array[i][0] == menutype.dropdown_override{
						on_pick = other.menu_array[i][2];
						on_pick_post = function(){
							if is_lq(submenu_creator){
								with(submenu_creator){
									menu_close_subs();	
								}
							}
						}
					}
					
					y_goal = _yst + 4;
					var _y = y;
					y = y_goal;
					image_yscale = string_height(display_name) / (sprite_get_height(sprite_idle));
					bbox_bottom = y + sprite_get_height(sprite_idle) * image_yscale;
					_yst = bbox_bottom;
					y = _y;
				}
				array_push(menu_active, _temp);
			}
		}else{
			menu_close_subs();
		}
	}
	on_step = undefined;
	on_draw = function(){
		draw_sprite(sprBasic9Slice_Cyan, 0, x, y);
		var _spr = sprite_idle;
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
		draw_set_font(fntChat);
		image_xscale = string_width(display_name) / (sprite_get_width(_spr));
		image_yscale = string_height(display_name) / (sprite_get_height(_spr));
		
		bbox_left = x;
		bbox_right = x + sprite_get_width(_spr) * image_xscale;
		bbox_top = y;
		bbox_bottom = y + sprite_get_height(_spr) * image_yscale;
		// Fancy; Cleans up the menus
		var i, o = 0;
		var _bb = bbox_right;
		for(i = 0;i<array_length(menu_active);i++){	
			if is_lq(menu_active[i]){
				if menu_active[i].cleanup == true{
					o++
				}
			}else o++;
		}
		if i == o{
			menu_active = [];	
		}
			
		if instance_exists(creator) && (xygoal_updated) && !is_lq(creator){
			if variable_instance_exists(creator,"active"){
				active = creator.active;
				if menu_get() != creator{
					x_goal = -x_goal_start;
					y_goal = -y_goal_start;
				}else{
					x_goal = x_goal_start;
					y_goal = y_goal_start;
				}
			}
		}
		if !(active){
			x_goal = xstart;
			y_goal = ystart;
			if x == x_goal && y = y_goal{
				cleanup = true;
			}
		}
		//trace(display_name,"SUBMENUS:",array_length(menu_active));
		for(var i = 0;i<array_length(menu_active);i++){
			try{
				menu_active[i].on_draw();	
			}catch(_error){
				show_message(_error);
				array_delete(menu_active, i, 1);
				i --;
			}
		}
		// If the mouse is in the current element, draw the Active sprite instead,
		   // and perform on_pick(); when the mouse button is RELEASED
		   // (sorry for yelling, I was yelling at myself as I typed that)
		   // (please understand)
		if !(cleanup) && point_in_rectangle(_mx,_my, x, y, x + (image_xscale * 9), y + (image_yscale * 9)){
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
			// Draw Text for button
			draw_set_font(fntChat);
			draw_set_valign(fa_center);
			draw_set_halign(fa_center); //fa_left);
			draw_set_color(c_white);
			var __scale = 0.90; // 0.80;
			draw_text_transformed(bbox_left + floor((bbox_right - bbox_left) / 2),bbox_top + ceil((bbox_bottom - bbox_top)/2),display_name, __scale, __scale, 0);
		};
		// Draws the sprite
		// By default this is mskNone so it's effectively drawing nothing
		draw_sprite(sprite_index,current_frame % 0.20,x,y);
	}
	// This performs the on_draw event AFTER the standard draw event
	on_draw_post = undefined;
}
function MenuItem_DropDown_Create(_x, _y, _displayName){
	if !var_in_self("MenuItem"){
		MenuItem = ds_list_create();
	}
	if !ds_exists(MenuItem,ds_type_list){
		MenuItem = ds_list_create();	
	}
	var _MenuObject = new MenuObject_DropDown(_x, _y, _displayName);
	_MenuObject.creator = id;
	ds_list_add(MenuItem,_MenuObject);	
	return MenuItem[|ds_list_size(MenuItem) - 1];
}