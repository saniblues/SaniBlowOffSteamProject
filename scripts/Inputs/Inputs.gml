// Input handler
function button_init(){
	enum INPUTLEVEL{
		player = 0,
		dialogue = 1,
		menu = 2,
		terminate = 10
	}
	global.InputActive = [];
	for(var i = 0;i<INPUTLEVEL.terminate;i++){
		global.InputActive[i] = true;
	}
	for(var i = 0;i<=3;i++){
		// Initializes defaults first. By default, every input handler is set to use the keyboard with default controls
		// Additionally, Input 1 is the only one enabled by default		
		// Set default values for player inputs. These can be changed via settings
		
		// Also note that by default, the gamepad device is set to the same value as the player
		//  IE, Player 1(0) is gamepad 0, P2(1) is set to 1, etc
		//  In a singleplayer setting, it's only necessary to set A gamepad for P1, so we can afford to be
		//  a little more greedy and set it to any active gamepad
		global.PlayerInput[i] = {
			inputList : ds_list_create(),
			enabled : true,//i == 0,
			gamepad : false,
			gamepad_sep_dir_inputs : true, // Separates Dpad inputs from left stick inputs
			gp_device : i,
			gp_deadzone : 0.25,
			gp_axisL_direction : 0,
			gp_axisL_lastdirection : 0,
			gp_axisL_strength : 0,
			gp_axisR_direction : 0,
			gp_axisR_lastdirection : 0,
			gp_axisR_strength : 0,
			key_p : [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			key : [
				"W","S","A","D",vk_space,mb_left,mb_right,"E",vk_shift,"Q",vk_enter,vk_escape,vk_up,vk_down,vk_left,vk_right
			],
			key_alt : [
				vk_up,vk_down,vk_left,vk_right,vk_space,mb_left,mb_right,"Z",vk_shift,"Q",vk_enter,vk_escape,vk_up,vk_down,vk_left,vk_right
			],
		}
		//var cantUseTernaryInStructsRIP = (i == 0 ? true : false);
		// I just want to leave the above comment as a reminder
		
	}
	#macro INPUT global.PlayerInput
	#macro input_target INPUT[0].inputList
	#macro Tracelog UberCont
	
	#macro gp_xbox_a gp_face1
	#macro gp_xbox_b gp_face2
	#macro gp_xbox_x gp_face3
	#macro gp_xbox_y gp_face4
	
	#macro KEY_ANY -1                   // Used in some places
	#macro KEY_UP 0                     // W
	#macro KEY_DOWN 1                   //S
	#macro KEY_LEFT 2                   //A
	#macro KEY_RIGHT 3                  //D
	#macro KEY_JUMP 4                   // Space
	#macro KEY_FIRE 5                   // LMB
	#macro KEY_CONFIRM 5                // Also LMB
	#macro KEY_SPEC 6                   // RMB
	#macro KEY_CANCEL 6                 // Also RMB
	#macro KEY_PICK 7                   // E
	#macro KEY_L1 8                     // LShift
	#macro KEY_R1 9                     // Space
	#macro KEY_SELECT 10                // E? Enter? Undecided
	#macro KEY_START 11                 // Esc. Uberpause.
	#macro KEY_ESC 11                   // Look man, I won't remember this shit
	
	#macro KEY_DPAD_UP 12               // Used
	#macro KEY_DPAD_DOWN 13             // For
	#macro KEY_DPAD_LEFT 14             // Gamepad
	#macro KEY_DPAD_RIGHT 15            // Dpads
}
function input_level_is_enabled(_level){
	if !range(_level, 0, INPUTLEVEL.terminate) return false;
	return global.InputActive[_level] == true;
}
function input_level_is_paused(_level){
	if !range(_level, 0, INPUTLEVEL.terminate) return false;
	return global.InputActive[_level] == false;
}
function input_level_pause(_level){
	if !range(_level, 0, INPUTLEVEL.terminate) return false;
	global.InputActive[@_level] = false;
}
function input_level_resume(_level){
	if !range(_level, 0, INPUTLEVEL.terminate) return false;
	global.InputActive[@_level] = true;
}

function button_step(){
	for(var i = 0;i<=3;i++){
		if(INPUT[i].enabled == true){
			for(var o = 0;o<array_length(INPUT[i].key_p);o++){
				// Key states: 0 = Unpressed, 1 = Pressed, 2 = Held, 3 = Released
				// Input has already been made, increment accordingly
				if INPUT[i].key_p[o] != 0{
					INPUT[i].key_p[@o] ++;
					if INPUT[i].key_p[o] == 4{
						INPUT[i].key_p[@o] = 0;	
					}
				}
			}
			// Store last gamepad direction
			INPUT[i].gp_axisL_lastdirection = INPUT[i].gp_axisL_direction;
			// Check for inputs after incrementing
			for(var o = 0;o<array_length(INPUT[i].key);o++){
				if !(INPUT[i].gamepad) || !(global.gamepadIsSupported){
					if (!batch_compare(INPUT[i].key[o],mb_left,mb_right)){
						var k = INPUT[i].key[o];
						if is_string(INPUT[i].key[o]){
							k = ord(k);
						}
						if keyboard_check(k){
							INPUT[i].key_p[@o] = median(1,INPUT[i].key_p[o],2);
						}
					}else{
						if mouse_check_button(INPUT[i].key[o]){
							INPUT[i].key_p[@o] = median(1,INPUT[i].key_p[o],2);
						}
					}
				}else{
					if gamepad_is_connected(INPUT[i].gp_device){
						var dev = INPUT[i].gp_device;
						if gamepad_axis_count(dev) > 0{
							// Temporary. Please don't set this every frame, thanks.
							gamepad_set_axis_deadzone(dev,INPUT[i].gp_deadzone);
						
							// Left axis
							var haxis = gamepad_axis_value(dev, gp_axislh);
							var vaxis = gamepad_axis_value(dev, gp_axislv);
							INPUT[i].gp_axisL_direction = point_direction(0, 0, haxis, vaxis);
							INPUT[i].gp_axisL_strength = point_distance(0,0, haxis, vaxis);
							var str = INPUT[i].gp_axisL_strength;
							
							// When sep_dir_inputs is set to false, stick inputs are read as analog inputs
							// This functionality is game-dependent and the control scheme should be factored around this
							if INPUT[i].gamepad_sep_dir_inputs == false{
								// Analogue inputs
								if (haxis * str > gamepad_get_axis_deadzone(dev) || gamepad_button_check(dev,gp_padr)){
									INPUT[i].key_p[@KEY_RIGHT] = median(1,INPUT[i].key_p[KEY_RIGHT],2);
								}else if (haxis * str < -gamepad_get_axis_deadzone(dev) || gamepad_button_check(dev,gp_padl)){
									INPUT[i].key_p[@KEY_LEFT] = median(1,INPUT[i].key_p[KEY_LEFT],2);
								}
								if (vaxis * str > gamepad_get_axis_deadzone(dev) || gamepad_button_check(dev,gp_padd)){
									INPUT[i].key_p[@KEY_DOWN] = median(1,INPUT[i].key_p[KEY_DOWN],2);
								}else if (vaxis * str < -gamepad_get_axis_deadzone(dev) || gamepad_button_check(dev,gp_padu)){
									INPUT[i].key_p[@KEY_UP] = median(1,INPUT[i].key_p[KEY_UP],2);
								}
							}else{
								// Dpad/Stick are separated, register as their own inputs
								var ar1 = [gp_padu, gp_padd, gp_padl, gp_padr];
								var ar2 = [KEY_DPAD_UP, KEY_DPAD_DOWN, KEY_DPAD_LEFT, KEY_DPAD_RIGHT];
								for(var p = 0;p<4;p++){
									if gamepad_button_check(dev,ar1[p]){
										INPUT[i].key_p[@ar2[p]] = median(1, INPUT[i].key_p[ar2[p]],2);
									}
								}
							}
							// Right axis
							// It doesn't automatically input like the left axis, therefore it isn't needed
							// In fact, I intend to use it only to shift the view around like Crosscode and NT do
							var haxis = gamepad_axis_value(dev, gp_axisrh);
							var vaxis = gamepad_axis_value(dev, gp_axisrv);
							if abs(haxis) + abs(vaxis) > INPUT[i].gp_deadzone{
								INPUT[i].gp_axisR_lastdirection = point_direction(0,0,haxis,vaxis);
							}
							INPUT[i].gp_axisR_direction = point_direction(0, 0, haxis, vaxis);
							INPUT[i].gp_axisR_strength = point_distance(0,0, haxis, vaxis);
							
							var ar1 = [gp_xbox_a,gp_xbox_b,gp_xbox_x,gp_xbox_y,gp_select ,gp_start ,gp_shoulderl,gp_shoulderr];
							var ar2 = [KEY_JUMP ,KEY_FIRE ,KEY_SPEC ,KEY_PICK ,KEY_SELECT,KEY_START,KEY_L1      ,KEY_R1];
							for(var p = 0;p < array_length(ar1);p++){
								if gamepad_button_check(dev,ar1[p]){
									INPUT[i].key_p[@ar2[p]] = median(1,INPUT[i].key_p[ar2[p]],2);
								}
							}
						}
					}
				}
			}
		}
	}
}
function button_pressed(_priority, _key){
	if input_level_is_enabled(_priority){
		//if !(self == input_get_priority_target()) return false;
		if _key == KEY_ANY{
			for(var i = 0;i<array_length(INPUT[0].key_p);i++){
				if INPUT[0].key_p[i] == true{
					return true;	
				}
			}
			return false;
		}
		return INPUT[0].key_p[_key] == 1;
	}
	return false;
}
function button_check(_priority, _key){
	if input_level_is_enabled(_priority){
		//if !(id == input_get_priority_target()) return false;
		if _key == KEY_ANY{
			for(var i = 0;i<array_length(INPUT[0].key_p);i++){
				if batch_compare(INPUT[0].key_p[i], 1, 2){
					return true;	
				}
			}
			return false;
		}
		return batch_compare(INPUT[0].key_p[_key], 1, 2);
	}
	return false;
}
function button_released(_priority, _key){
	if input_level_is_enabled(_priority){
		//if !(id == input_get_priority_target()) return false;
		if _key == KEY_ANY{
			for(var i = 0;i<array_length(INPUT[0].key_p);i++){
				if INPUT[0].key_p[i] == 3{
					return true;	
				}
			}
			return false;
		}
		return INPUT[0].key_p[_key] == 3;
	}
	return false;
}
function button_get_key(_i){
	return INPUT[0].key[_i];	
}
function button_set_key(_i, _o){
	INPUT[0].key[@_i] = _o;	
}