// Various functions that I use on the reg
function instances_find_area(_object_or_array){
	var _inst = _object_or_array;
	if !is_array(_inst){
		with(_object_or_array){
			array_push(_inst);	
		}
	}
	var _x1 = 999999, _y1 =999999, _x2 = -99999, _y2 = -99999;
	for(i = 0;i<array_length(_inst);i++){
		with(_inst[i]){
			_x1 = min(bbox_left, _x1);
			_y1 = min(bbox_top, _y1);
			_x2 = max(bbox_right, _x2);
			_y2 = max(bbox_bottom, _y2);
		}
	}
	return [_x1, _y1, _x2, _y2];
}
function sleep(_frames){
	// Sets this variable in o_Game because we don't want multiple sleep(); calls stacking
	//  Reason being, we don't want a bunch of things to make the game freeze for an extended
	//  period of time. 
	with(UberCont){
		sleep_frames = max(_frames, sleep_frames);
		sleep_delay = 4;
	}
}
function debug_drag_step(){
	// Run this in any objects that we want to add this functionality to
	//  Lets us click on objects while holding shift to drag them
	//  The changes are NOT permanent. Make sure to actually edit things when you're placing them
	//if !(DEBUG) exit;
	// Initialize the script
	if !var_in_self("debug_dragging"){
		debug_dragging = false;
		drag_xoff = 0;
		drag_yoff = 0;
	}
	
	var sw = sprite_width/2, sh = sprite_height/2;
	if button_check(0,KEY_L1) && button_pressed(0,KEY_FIRE){
		var _bbox = new bbox(id);
		
		/*
			Creates a red rectangle around the entire sprite
			I was debugging this (tl;dr I was using crunched coordinates) but maybe this will come up later
			so *ahem*; HITBOX VIEWER
		*/
		
		with(script_bind()){
			depth = -99999;
			x = other.x;
			y = other.y;
			sprite_index = other.sprite_index;
			mask_index = other.mask_index;
			bbox_temp = new bbox(id);
			on_draw = function(){
				draw_set_color(c_red);
				draw_rectangle(bbox_temp.sprite_left, bbox_temp.sprite_top, bbox_temp.sprite_right, bbox_temp.sprite_bottom,1);
				draw_set_color(c_lime);
				draw_rectangle(bbox_temp.left, bbox_temp.top, bbox_temp.right, bbox_temp.bottom, 1);
			}
			schedule(room_speed, function(){
				delete bbox_temp;
				instance_destroy();
			});
		}
		if point_in_rectangle(mouse_x,mouse_y,_bbox.sprite_left, _bbox.sprite_top, _bbox.sprite_right, _bbox.sprite_bottom){
			debug_dragging = true;
			drag_xoff = mouse_x - x;
			drag_yoff = mouse_y - y;
		}
		
		delete _bbox;
	}
	if (debug_dragging){
		var _xp = x, _yp = y;
		x = lerp(x,mouse_x + drag_xoff,0.1);
		y = lerp(y,mouse_y + drag_yoff,0.1);
		x=round(x);
		y=round(y);
		if var_in_self("hspd"){
			hspd -= diff(_xp,x) / 2;
			vspd -= diff(_yp,y) / 2;
			hspd_extra = absdiff(3,hspd);
			vspd_extra = absdiff(4,vspd);
		}
		if !button_check(0,KEY_FIRE){
			debug_dragging = false;
		}
	}
}
function bbox_grid(_id) constructor{
	left = _id.bbox_left div 16;
	top = _id.bbox_top div 16;
	right = _id.bbox_right div 16;
	bottom = _id.bbox_bottom div 16;
	
	var _x = _id.x, _y = _id.y, _wid = sprite_get_width(_id.sprite_index) / 2, _hig = sprite_get_height(_id.sprite_index) / 2;
	sprite_left = (_x - _wid) div 16;
	sprite_top = (_y - _hig) div 16;
	sprite_right = (_x + _wid) div 16;
	sprite_bottom = (_y + _hig) div 16;
}
function bbox(_id) constructor{
	left = _id.bbox_left;
	top = _id.bbox_top;
	right = _id.bbox_right;
	bottom = _id.bbox_bottom;
	
	var _x = _id.x, _y = _id.y, _wid = sprite_get_width(_id.sprite_index) / 2, _hig = sprite_get_height(_id.sprite_index) / 2;
	sprite_left = (_x - _wid);
	sprite_top = (_y - _hig);
	sprite_right = (_x + _wid);
	sprite_bottom = (_y + _hig);
}
function collision_at_visual(_x,_y){
	return collision_at(_x,_y);
	with(instance_create(_x,_y,par_Effect)){
		sprite_index = sprEmmi_SanicJump;	
	}
	return collision_at(_x,_y);
}
function collision_at(_x,_y){
	_x = _x div TILE_WIDTH;
	_y = _y div TILE_HEIGHT;
	var source_layer = layer_get_id("Collision");
	var collision_layer = layer_tilemap_get_id(source_layer);
	return tilemap_get(collision_layer,_x,_y);
}
function place_meeting_grid(_x, _y, _obj){
	if !instance_exists(id) || !instance_exists(_obj) return false;
	var _r = 0;
	var _bbox = new bbox_grid(id);
	with(_obj){
		var __bbox = new bbox_grid(id);
		if ((_bbox.sprite_left == __bbox.sprite_left) + (_bbox.sprite_top == __bbox.sprite_top) + (_bbox.sprite_right == __bbox.sprite_right) + (_bbox.sprite_bottom == __bbox.sprite_bottom)) >= 3{
			_r = true;
			delete __bbox;
			break;
		}else if place_meeting(x,y,other){
			delete __bbox;
			_r = true;
		}
		delete __bbox;
	}
	delete _bbox;
	return _r;
}

function var_in_self(_var){
	// Shorter version of variable_instance_exists. Serves no other purpose.
	return variable_instance_exists(id, string(_var));
}
function var_local(_var){
	return var_in_self(_var) ? variable_instance_get(id, string(_var)) : false;
}
function bbox_hmid(_id){
	// Horizontal center of an object
	return _id.bbox_left + ((_id.bbox_right - _id.bbox_left) / 2);
}
function bbox_vmid(_id){
	// Vertical center of an object
	return _id.bbox_top + ((_id.bbox_bottom - _id.bbox_top) / 2);
}
// Legacy
function instance_create(){
	var _args = [0,0,0,"Instances"];
	for(var i = 0;i<argument_count;i++){
		_args[@i] = argument[i];
	}
	var _x = _args[0], _y = _args[1], _obj = _args[2], _layer = layer_get_id(string(_args[3]));
	if object_exists(_obj){
		with(instance_create_layer(_x,_y,_layer,_obj)){
			return id;	
		}
	}else return -4;
}


// Logics
function batch_compare(){
	for(var i = 1;i<argument_count;i++){
		if argument[0] == argument[i]{
			return true;
		}
	}
	return false;
}
function batch_compare_array(){
	for(var i = 1;i<argument_count;i++){
		if is_array(argument[i]){
			for(var o = 0;o<array_length(argument[i]);o++){
				if argument[i][@o] = argument[0]{
					return true;
				}
			}
		}else{
			if argument[0] == argument[i]{
				return true;
			}
		}
	}
	return false;
}
function range(_a, _b, _c){
	return _a >= min(_b, _c) && _a <= max(_b, _c);
}
function cycle(Value,Min,Max){
	var result, delta;
	delta = (Max - Min);
	result = (Value - Min) mod delta;
	if (result < 0) result += delta;
	return result + Min;	
}
// NTT-compliant struct hooks
// Just because I'm more familiar with them
function lq_exists(_obj){
	return is_struct(_obj);//is_lq(_obj);
}
function is_lq(_obj){
	return is_struct(_obj);	
}
function lq_set(_obj,_var,_val){
	if is_lq(_obj){
		variable_struct_set(_obj,string(_var),_val);
	}
}
function lq_get(_obj,_var){
	if is_lq(_obj){
		return variable_struct_get(_obj,_var)
	}
	return -1;
}
function lq_defget(_obj,_var,_def){
	if is_lq(_obj){
		if variable_struct_exists(_obj,string(_var)){
			return variable_struct_get(_obj,string(_var));
		}
	}
	return _def;
}
// Tracelog
function trace_init(){
	global.MacroVars = {
		tracelog : ds_list_create(),
		tracetime : 0,
		tracesize : 20,
		tracefont : fntM,
		currentframe : 0,
		currenttimescale : 1,
	}
	
	#macro TRACELOG global.MacroVars.tracelog
	#macro trace_frame global.MacroVars.tracetime
	#macro trace_size global.MacroVars.tracesize
	#macro trace_font global.MacroVars.tracefont
	#macro current_frame global.MacroVars.currentframe
	#macro current_time_scale global.MacroVars.currenttimescale
	#macro base_time_scale room_speed/60
}
function trace(){
		var str = "";
		for(var i = 0;i<argument_count;i++){
			str += string(argument[i]);
			// Add an additional space
			if i < argument_count - 1{
				str += " ";
			}
		}
		ds_list_add(TRACELOG,str);
		
		return str;
}
function trace_error(){
		var str = "";
		for(var i = 0;i<argument_count;i++){
			str += string(argument[i]);
			// Add an additional space
			if i < argument_count - 1{
				str += " ";
			}
		}
		ds_list_add(TRACELOG,str);
		
		return true;
}

function trace_time(){
		// Shows a difference in trace times in ms
		// Intended to be used to show performance differences
		var str = "";
		for(var i = 0;i<argument_count;i++){
			str += string(argument[i]);
			// Add an additional space
			if i < argument_count - 1{
				str += " ";
			}
		}
		if trace_frame != 0{
			str += string_from_args(" >",string(current_time - trace_frame) + "MS (",string((current_time - trace_frame)/1000),"SEC )");
			trace_frame = 0;	
		}else trace_frame = current_time;
		ds_list_add(TRACELOG,str);
		return true;
}

// Strings
function string_from_args(){
	var str = "";
	for(var i = 0;i<argument_count;i++){
			str += string(argument[i]);
			if i < argument_count - 1{
				str += " ";	
			}
	}
	return str;
}

function string_tokenize(_str){
	var ar = [];
	
	return ar;
}

// Maths/Logics/Collisions
function place_meeting_ext(_x, _y, _obj, _mask, _xsc, _ysc, _ang){
    // Remember these for later
    var xx = x, yy = y, msk = mask_index, xsc = image_xscale, ysc = image_yscale, ang = image_angle;
    // Move to position and apply fields
    x = _x; y = _y; image_xscale = _xsc; image_yscale = _ysc; image_angle = _ang; mask_index = _mask;
    // This is the bread and butter. Try not to stand up too fast!
    var _r = place_meeting(x,y,_obj);
    // Move everything back
    x = xx; y = yy; mask_index = msk; image_xscale = xsc; image_yscale = ysc; image_angle = ang;
  
    return _r;
}

function array_push(array,value)
{
    var len = array_length(array);

    if (len == 0)
    {
        array[@0] = value;
    }
    else
    {
        array[@len+1]=value;
    }
}
function array_clone(_array){
	if !is_array(_array) return [];
	var _arg = [];
	for(var i = 0;i<array_length(_array);i++){
		_arg[@i] = array[i];
	}
	return _arg;
}
function foreach(_ar, _func){
	if !is_array(_ar) || array_length(_ar) == 0 exit;
	if !is_method(_func) exit;
	for(var i = 0;i<array_length(_ar);i++){
		with(_ar[i]) _func(_ar[i].id);
	}
}
function instances_matching(){
	if argument_count < 2 return []; // Nope lol
	var _obj = argument[0], _var = string(argument[1]), _ar = [];
	for(var i = 2;i<argument_count;i++){
		with(_obj){
			if variable_instance_exists(id, _var){
				if variable_instance_get(id, _var) == argument[i]{
					array_push(_ar, id);
				}
			}
		}
	}
	return _ar;
}
function instances_matching_ne(){
	if argument_count < 2 return []; // Nope lol
	var _obj = argument[0], _var = string(argument[1]), _ar = [];
	for(var i = 2;i<argument_count;i++){
		with(_obj){
			if variable_instance_exists(id, _var){
				if variable_instance_get(id, _var) != argument[i]{
					array_push(_ar, id);
				}
			}
		}
	}
	return _ar;
}
function instances_matching_gt(){
	if argument_count < 2 return []; // Nope lol
	var _obj = argument[0], _var = string(argument[1]), _ar = [];
	for(var i = 2;i<argument_count;i++){
		with(_obj){
			if variable_instance_exists(id, _var){
				if variable_instance_get(id, _var) > argument[i]{
					array_push(_ar, id);
				}
			}
		}
	}
	return _ar;
}
function instances_meeting(_x,_y,_obj){
	// Performs a bbox-to-bbox collision for non-precise collision checks
	var ar = [];
	with(_obj){
		if rectangle_in_rectangle(other.bbox_left,other.bbox_top,other.bbox_right,other.bbox_bottom,bbox_left,bbox_top,bbox_right,bbox_bottom){
			array_push(ar,id);
		}
	}
	return ar;
}
function instances_meeting_rect(x1,y1,x2,y2,_obj){
	// Similar to the above, but performs rect-to-bbox collisions instead
	var ar = [];
	with(_obj){
		if rectangle_in_rectangle(x1,y1,x2,y2,bbox_left,bbox_top,bbox_right,bbox_bottom){
			array_push(ar,id);
		}
	}
	return ar;
}
function is_really_real(_real){
	return (real(_real) != 0) || (real(_real) == 0 && _real != "0");
}
function room_is_blacklisted(_room){
	var _ar = [
		// Init Room. Do not remove please!!
		a_RoomInit,
	];
	return batch_compare_array(_room, _ar);
}

function instance_is(_id, _family){
	if !instance_exists(_id) return false;
	return object_is_ancestor(_id.object_index, _family) || _id.object_index == _family;
}
function variable_instance_defget(_id, _var, _def){
	var _res = variable_instance_get(_id, _var);
	return is_undefined(_res) ? _def : _res;
}

function string_split(_str, _delim){
	if !is_string(_str) || !is_string(_delim){
		return ["<<undefined>>"]	
	}
	var ar = [];
	while(string_pos(_delim, _str)){
		var _p = string_pos(_delim, _str);
		var _str2 = string_copy(_str, 1, _p);
		if _p != 1 array_push(ar, _str2);
		_str = string_delete(_str, 1, _p);
	}
	if _str != _delim{
		array_push(ar, _str);
	}
	
	// Remove whitespace
	for(var i = 0;i<array_length(ar);i++){
		do{
			if batch_compare(string_char_at(ar[i],string_length(ar[i]))," ", _delim){
				ar[i] = string_delete(ar[i],string_length(ar[i]),1);	
			}
		}until !batch_compare(string_char_at(ar[i],string_length(ar[i]))," ", _delim);
	}
	
	return ar;
}

function string_split_opencase(){
	var _args = [undefined, undefined, undefined, undefined, undefined, undefined];
	for(var i = 0;i<argument_count;i++){
		_args[i] = argument[i];
	}
	// Return an array that says "<<undefined>>" if something stupid happens
	if !is_string(_args[0]) || !is_string(_args[1]){
		return ["<<undefined>>"];
	}
	// UberCases not found; put curlywurlies in place of crooked carrots
	if !string_count(_args[2], _args[0]){
		trace(_args[2],"NOT FOUND! USING",_args[4],"INSTEAD!");
		_args[@2] = _args[4];
		_args[@3] = _args[5];
	}
	// Use regular string_split(); if open/close cases aren't found
	if is_undefined(_args[2]) || is_undefined(_args[3]) || string_count(string(_args[2]), _args[0]) == 0{
		return string_split(_args[0], _args[1]);
	}
	// *chuckles* I copypasted the old one and changed a couple of things
	var _str = _args[0], _delim = _args[1], _open = [string(_args[2]), string(_args[4])], _close = [string(_args[3]), string(_args[5])];
	var ar = [];
	
	for(var i = 0;i<=1;i++){
		while(string_pos(_delim, _str) || (string_pos(_open[i], _str) && string_pos(_close[i],_str))){
			var _p = string_pos(_delim, _str); // Deliminator position first
			var _o = string_pos(_open[i], _str); // Open Case next
			var _c = string_pos(_close[i], _str); // Close Case last
			var _str2 = string_copy(_str, 1, _p); // Live string
			// Opencase is found; Set "delim position" to closeCase pos instead
			if _o == 1{
				_p = _c ? min(_c, string_length(_str)) : string_length(_str);
				_str2 = string_copy(_str, _o, _p);
			}else{
				_str2 = string_copy(_str, 1, _p);
			}
			// Push string if it is a string, with words
			if string_length(_str2) > 0{
				array_push(ar, _str2);
			}
			_str = string_delete(_str, 1, _p);
		
			// If the Open Case was found, delete any instances of the deliminator afterwards just to be safe
			if _o == 1{
				if string_char_at(_str, 1) == _delim{
					do{
						_str = string_delete(_str, 1, 1);
					}until string_char_at(_str, 1) != _delim || string_length(_str) == 0;
				}
			}
		}
	}
	
	// Remove whitespace
	for(var i = 0;i<array_length(ar);i++){
		do{
			if batch_compare(string_char_at(ar[i],string_length(ar[i]))," ", _delim){
				ar[i] = string_delete(ar[i],string_length(ar[i]),1);	
			}
		}until !batch_compare(string_char_at(ar[i],string_length(ar[i]))," ", _delim);
	}
	// Push array
	return ar;
}
function string_split_opencase_ye_olde(_str, _delim, _openCase, _closeCase){
	/* HERE YE HERE YE
	 * This crap is left here in the event that something STUPID happens and we need to revert to a previously functional thing
	 * without having to go through github to do it. I sani and actually not very smart and this happens often, HOWEVER it doesn't
	 * impact performance so there shouldn't be an issue!
	 *																		~ Ye Olde Saniblues
	 */
	// Make sure these
	if !is_string(_str) || !is_string(_delim){
		return ["<<undefined>>"];
	}
	// trace(_openCase, _closeCase);
	if is_undefined(_openCase) || is_undefined(_closeCase) || string_count(_openCase,_str) == 0{
		return string_split(_str, _delim);
	}
	
	var ar = [];
	while(string_pos(_delim, _str) || (string_pos(_openCase, _str) && string_pos(_closeCase,_str))){
		var _p = string_pos(_delim, _str); // Deliminator position first
		var _o = string_pos(_openCase, _str); // Open Case next
		var _c = string_pos(_closeCase, _str); // Close Case last
		var _str2 = string_copy(_str, 1, _p); // Live string
		if _o == 1{
			_p = _c ? min(_c, string_length(_str)) : string_length(_str);
			_str2 = string_copy(_str, _o, _p);
		}else _str2 = string_copy(_str, 1, _p);
		
		// Push string if it is a string, with words
		if string_length(_str2) > 0{
			array_push(ar, _str2);
		}
		_str = string_delete(_str, 1, _p);
		
		// If the Open Case was found, delete any instances of the deliminator afterwards just to be safe
		if _o == 1{
			if string_char_at(_str, 1) == _delim{
				do{
					_str = string_delete(_str, 1, 1);
				}until string_char_at(_str, 1) != _delim || string_length(_str) == 0;
			}
		}
	}
	// If the string isn't empty after the loop, add it at the end since there's nothing else that can be added
	if _str != _delim && array_length(_str) > 0{
		array_push(ar, _str);
	}
	// Remove whitespace
	for(var i = 0;i<array_length(ar);i++){
		do{
			if batch_compare(string_char_at(ar[i],string_length(ar[i]))," ", _delim){
				ar[i] = string_delete(ar[i],string_length(ar[i]),1);	
			}
		}until !batch_compare(string_char_at(ar[i],string_length(ar[i]))," ", _delim);
	}
	// Push array
	return ar;
}

function diff(_val1, _val2){
	return (_val1 - _val2);	
}
function absdiff(_val1, _val2){
	return abs(_val1 - _val2);	
}

function variable_struct_null_to_undefined(_struct){
	if !is_lq(_struct) exit;
	var _keys = variable_struct_get_names(_struct);
	for(var i = 0;i<array_length(_keys);i++){
		if is_struct(lq_get(_struct,_keys[i])){
			lq_set(_struct,_keys[i],variable_struct_null_to_undefined(lq_get(_struct,_keys[i])));
		}else{
			if lq_get(_struct,_keys[i]) == pointer_null{
				lq_set(_struct,_keys[i],undefined);
			}
		}
	}
	return _struct;
}

//https://forum.yoyogames.com/index.php?threads/struct-nesting-issue-not-passing-by-reference.81056/#post-482427

function copy_deep(thing, source) {
    var copyType = typeof(thing);
    if (copyType != typeof(source)) throw "Trying to copy incompatible types";
    var copySize, thingEntry, sourceEntry, sourceType;
    switch (copyType) {
        case "array":
            copySize = array_length(source);
            array_resize(thing, copySize);
            for (var i = copySize-1; i >= 0; --i) {
                thingEntry = thing[i];
                sourceEntry = source[i];
                sourceType = typeof(sourceEntry);
                if (sourceType == typeof(thingEntry) && (is_array(thingEntry) || is_struct(thingEntry))) {
                    copy_deep(thingEntry, sourceEntry);
                } else {
                    array_set(thing, i, clone_deep(sourceEntry));
                }
            }
        break;
        case "struct":
            // Transfer their keys to mine
            var copyKeys = variable_struct_get_names(source);
            copySize = array_length(copyKeys);
            for (var i = copySize-1; i >= 0; --i) {
                var copyKey = copyKeys[i];
                thingEntry = variable_struct_get(thing, copyKey);
                sourceEntry = variable_struct_get(source, copyKey);
                sourceType = typeof(sourceEntry);
                if (sourceType == typeof(thingEntry) && (is_array(thingEntry) || is_struct(thingEntry))) {
                    copy_deep(thingEntry, sourceEntry);
                } else {
                    variable_struct_set(thing, copyKey, clone_deep(sourceEntry));
                }
            }
            // Set keys that are not theirs to undefined
            var myKeys = variable_struct_get_names(thing);
            var mySize = array_length(myKeys);
            for (var i = mySize-1; i >= 0; --i) {
                var myKey = myKeys[i];
                if (!variable_struct_exists(source, myKey)) {
                    //variable_struct_set(thing, myKey, undefined);
                }
            }
        break;
        default:
            return source;
    }
    return thing;
}

function clone_deep(thing) {
    var cloneType = typeof(thing);
    var theClone;
    switch (cloneType) {
        case "array":
            var cloneSize = array_length(thing);
            theClone = array_create(cloneSize);
            for (var i = cloneSize-1; i >= 0; --i) {
                theClone[i] = clone_deep(thing[i]);
            }
        break;
        case "struct":
            var cloneKeys = variable_struct_get_names(thing);
            theClone = {};
            for (var i = array_length(cloneKeys)-1; i >= 0; --i) {
                var cloneKey = cloneKeys[i];
                variable_struct_set(theClone, cloneKey, clone_deep(variable_struct_get(thing, cloneKey)));
            }
        break;
        default:
            return thing;
    }
    return theClone;
}


function struct_merge(primary, secondary, shared)	{
	var _ReturnStruct = primary;
	var _key = variable_struct_get_names(primary);
	show_message(string(_key) + "\nKEYS:" + string(array_length(_key)));
	for(var i = 0;i<array_length(_key);i++){
		if variable_struct_exists(secondary, _key[i]){
			show_message(lq_get(secondary,_key[i]));
			if is_lq(secondary,_key[i]){
				var _structA = lq_get(primary, _key[i])
				var _structB = lq_get(secondary, _key[i]);
				var _structC = struct_merge(_structA, _structB, true);
				show_message(string_from_args("STRUCTA",_structA));
				show_message(string_from_args("STRUCTB",_structB));
				show_message(string_from_args("STRUCTC",_structC));
				
			}else{
				variable_struct_set(primary, _key[i], variable_struct_get(secondary,_key[i]));	
			}
		}
	}
	return _ReturnStruct;
	/*
	var _ReturnStruct = primary;
	
	if (shared)	{
		var _PropertyNames = variable_struct_get_names(primary);
		for (var i = 0; i < array_length(_PropertyNames); i ++)	{
			if (variable_struct_exists(secondary, _PropertyNames[i]))	{
				for(var i = 0;i<array_length(variable_struct_get_names(secondary));i++){
					show_message(variable_struct_get(secondary,_PropertyNames[i]));
					//variable_struct_set(_ReturnStruct, _PropertyNames[i], variable_struct_get(
				}
				//variable_struct_set(_ReturnStruct, _PropertyNames[i], variable_struct_get(secondary, _PropertyNames[i]));
			}
			show_message(lq_get(_ReturnStruct,_PropertyNames[i]));
		}
	}	else	{
		var _PropertyNames = variable_struct_get_names(secondary);
		for (var i = 0; i < array_length(_PropertyNames); i ++)	{
			variable_struct_set(_ReturnStruct, _PropertyNames[i], variable_struct_get(secondary, _PropertyNames[i]));
		}
	}
	return _ReturnStruct;
	*/
}