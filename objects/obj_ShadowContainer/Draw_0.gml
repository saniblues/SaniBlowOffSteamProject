{
	//var _dw = display_get_gui_width(), _dh = display_get_gui_height();
	//display_set_gui_size(game_width,game_height);
	var _x = 0 - camera_get_view_x(view_camera[0]), _y = 0 - camera_get_view_y(view_camera[0]);
	//_x = 0; _y = 0;
	//_x = global.camera_lastpos[0] - camera_get_view_x(view_camera[0]); _y = camera_get_view_y(view_camera[0]) - global.camera_lastpos[1];
	if !surface_exists(surf){
		surf = surface_create(game_width,game_height);
	}
	surface_set_target(surf);
		draw_clear_alpha(c_black,0);
		var _id = layer_tilemap_get_id(target_layer)
		for(var i = view_xview div TILE_WIDTH;i<=(view_xview + game_width) div TILE_WIDTH;i++){
			for(var o = view_yview div TILE_HEIGHT;o<=(view_yview + game_height) div TILE_HEIGHT;o++){
				var _tile = tilemap_get(_id,i, o);
				if _tile != 0 draw_tile(lazytileset, _tile, 0, (i * TILE_WIDTH) - view_xview, (o * TILE_HEIGHT) - view_yview);
			}
		}
		//draw_tilemap(layer_tilemap_get_id(target_layer),_x, _y);
	surface_reset_target();
	/*
	if !surface_exists(surf_final){
		surf_final = surface_create(game_width,game_height);
	}
	surface_set_target(surf_final);
		draw_clear_alpha(c_black,0);
		shader_set(shd_blur);
		u_blur = shader_get_uniform(shd_blur, "size_radius");
		var _tw = surface_get_width(surf),_th = surface_get_height(surf);
		shader_set_uniform_f(u_blur, _tw, _th, 0.2);
		draw_surface_ext(surf,0,0,1,1,0,c_white,1);
		shader_reset();
	surface_reset_target();
	*/
	//draw_set_color(c_lime);
	//draw_rectangle(0,0,room_width,room_height,0);
	//gpu_set_blendmode_ext_sepalpha( bm_src_color , bm_dest_color , bm_one , bm_one );
	shader_set(shd_blur);
	u_blur = shader_get_uniform(shd_blur, "size_radius");
	var _tw = surface_get_width(surf),_th = surface_get_height(surf);
	shader_set_uniform_f(u_blur, _tw, _th, 0.15);
	draw_surface_ext(surf,camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]),1,1,0,c_white,1);
	shader_reset();
	//gpu_set_blendmode(bm_normal);
	//display_set_gui_size(_dw,_dh);
}