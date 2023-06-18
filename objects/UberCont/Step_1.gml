{
	// Input handler
	button_step();
	// Increments current_frame by current_time_scale at the beginning of each frame
	current_frame += current_time_scale;
	global.camera_lastpos = [camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0])];
}