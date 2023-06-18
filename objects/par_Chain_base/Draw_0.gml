{
	draw_self();
	for(var i = 0;i<array_length(joint);i++){
		with(joint[i]){
			draw_sprite(PLACEHOLDER_Missingno, 0, x, y);	
		}
	}
	if array_length(joint) > 1{
		for(var i = 1;i<joint_num-1;i++){
			var _prev = joint[i - 1], _live = joint[i], _temp = joint[i + 1];
			var _len = point_distance(_live.x,_live.y,_temp.x,_temp.y);
			var _dir = point_direction(_live.x,_live.y,_temp.x,_temp.y);
			
			var _dir1 = point_direction(_live.x,_live.y,_prev.x,_prev.y);
			var _dir2 = point_direction(_live.x,_live.y,_temp.x,_temp.y);
			
			draw_set_color(c_lime);
			draw_line(_prev.x,_prev.y,_live.x,_live.y);
			draw_set_color(c_aqua);
			draw_line(_temp.x,_temp.y,_live.x,_live.y);
			draw_set_color(c_white);
		}
	}
}