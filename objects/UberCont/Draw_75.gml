//if !(SETTING.debug.allow_tracelog) exit;
exit;
var xst = 8, yst = surface_get_height(application_surface) - round(font_get_size(trace_font) * 1.5) - 8;
draw_set_font(fntM);
draw_set_halign(fa_right);
draw_set_halign(fa_center);
// The actual tracelog stuff
//var _fnt = draw_get_font();
//draw_set_font(spr_font);
display_set_gui_size(window_get_width(), window_get_height());
var _scale = 1;
if(typing){
	input_string = keyboard_string;
	var fntHeight = string_height(">" + input_string) * _scale;
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	draw_set_color(c_gray);
	draw_set_alpha(0.5);
	draw_rectangle(0,yst + 1, xst + (string_width(">" + input_string) * _scale), yst + fntHeight, 0);
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_text_transformed(xst,yst,">" + input_string, _scale, _scale, 0);
	if keyboard_check_pressed(vk_enter){
		trace(input_string);
		if string_char_at(input_string,1) = "/"{
			chat_command(input_string);	
		}
		typing = false;
		input_string = "";
		keyboard_string = "";
	}
	yst -= fntHeight;
}else{
	if keyboard_check_pressed(ord("T")){
		typing = true;
		input_string = "";
		keyboard_string = "";
	}
	if !typing && keyboard_check_pressed(ord("/")){
		typing = true;
		input_string = "/";
		keyboard_string = "/";
	}
}
if ds_exists(TRACELOG,ds_type_list){
	for(var i = ds_list_size(TRACELOG) - 1;i>=max(0,ds_list_size(TRACELOG) - trace_size);i--){
		var fntHeight = string_height(TRACELOG[|i]) * _scale;;
		//yst -= 8;
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);
		draw_set_color(c_gray);
		draw_set_alpha(0.5);
		draw_rectangle(xst - 4,yst + 1, xst + (string_width(TRACELOG[|i]) * _scale) + 4, yst + fntHeight, 0);
		//draw_triangle(xst-4,yst,xst - 8, yst, xst-4, yst + 4, 0);
		draw_set_color(c_white);
		draw_set_alpha(1);
		//draw_set_font(fnt_pixelmix);
		draw_text_transformed(xst,yst,TRACELOG[|i], _scale, _scale, 0);
		yst -= fntHeight;
	}
}
// Inputs
xst = 8; yst = 8;

for(var i = 0;i<=0;i++){
	draw_sprite_ext(InputHUD, 0, xst + (64 * i), yst,2,2,0,c_white,1)	
	for(var o = 0;o<array_length(INPUT[i].key_p);o++){
		var frame = o + 1 + (range(o,KEY_DPAD_UP,KEY_DPAD_RIGHT)); // (INPUT[i].gamepad_sep_dir_inputs ? (o < 4 ? 0 : o + 1) : o + 1)
		if button_check(i, o) draw_sprite_ext(InputHUD,frame,xst + (64 * i), yst,2,2,0,c_white,1);
	}
	// Draw axis
	if INPUT[i].gamepad && gamepad_axis_count(i) > 0{
		// Left stick
		xst += (64 * i);
			xst += 20;
			yst += 32;
			var lenL = INPUT[i].gp_axisL_strength * 5, dirL = INPUT[i].gp_axisL_direction;
			var lenR = INPUT[i].gp_axisR_strength * 5, dirR = INPUT[i].gp_axisR_direction;
			draw_set_color(c_white);
			draw_circle(xst, yst, 5, 0);
			draw_set_color(c_red);
			draw_line(xst,yst,xst + lengthdir_x(lenL, dirL), yst + lengthdir_y(lenL,dirL));
			// Right stick
			xst += 20;
			draw_set_color(c_white);
			draw_circle(xst, yst, 5, 0);
			draw_set_color(c_red);
			draw_line(xst,yst,xst + lengthdir_x(lenR, dirR), yst + lengthdir_y(lenR,dirR));
			xst -= 24 + 16;
			yst -= 32;
		xst -= (64 * i);
		draw_set_color(c_white);
	}
}

//draw_set_font(_fnt);