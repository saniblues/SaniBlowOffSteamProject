// Build pixel collisions based on the collision tilemap
var source_layer = layer_get_id("Collision");
var collision_layer = layer_tilemap_get_id(source_layer);
	
var _origin = tilemap_get_at_pixel(collision_layer, 0, 0);
for(var i = 0;i<room_width;i+=TILE_WIDTH){
	for(var o = 0;o<room_height;o+=TILE_HEIGHT){
		var _val = tilemap_get(collision_layer, i div TILE_WIDTH, o div TILE_HEIGHT);
		if !batch_compare(_val, -1, 0){
			//tilemap_set_at_pixel(collision_layer,0,i,o);
			with(instance_create(i,o,par_CollisionObject)){
				visible = false;
				made_for_level = true;
				image_index = ((_val <= 3) ? 0 : 1 + _val - 4);
				xstart = x; ystart = y;
				if(_val == 2){
					destructible = true;
					//image_blend = c_red;
					image_index = 0;
				}else if (_val == 3){
					destructible = true;
					actually_destructible = false;
				}else if (_val == 24){
					destructible = true;
					actually_destructible = false;
					actually_solid = false;
					sprite_index = spr_ghostblock;
				}
				//24
				//if _val >= 12 trace("TILE NUMBER",_val,"?",(_val >= 12 ? "LONG" : "NOT LONG!"));
					
				//visible = true;
			}
		}
	}
}
layer_set_visible(source_layer,false);
/*
// Sets outline shader
function __scriptTempBegin(){
	if (event_type == ev_draw) {
		if (event_number == ev_draw_normal) {
			if !variable_global_exists("floorSurface"){
				global.floorSurface = -1;	
			}
			if (!surface_exists(global.floorSurface)) {
				global.floorSurface = surface_create(room_width, room_height);
			}

			surface_set_target(global.floorSurface);
			draw_clear_alpha(c_black, 0);
		}
	}
}
function __scriptTempEnd(){
	if (event_type == ev_draw) {
		if (event_number == ev_draw_normal){
			surface_reset_target();
		}else if (event_number == ev_draw_end) {
			//draw_surface(global.floorSurface, 0, 0);
			
			shader_set(shd_blur);
				var _tex = surface_get_texture(global.floorSurface);
				u_blur = shader_get_uniform(shd_blur, "size_radius");
				shader_set_uniform_f(u_blur, room_width, room_height, 0.2);
				draw_surface(global.floorSurface, 0, 0);
			shader_reset();
			
			draw_surface_ext(global.floorSurface,camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]),0.33,0.33,0,c_white,1);
		}
	}
}

layer_script_begin("GroundTiles_Darkness", __scriptTempBegin);
layer_script_end("GroundTiles_Darkness", __scriptTempEnd);
*/
{
	var _ar = layer_get_all();
	var fx_layers = ["GroundTiles_Darkness"];
	for(var i = 0;i<array_length(_ar);i++){
		// Scans the layers to see if they are in fact, background layers
		var _a = layer_get_all_elements(_ar[i]);
		var _r = false;
		var _id = -1;
		for(var o = 0;o<array_length(_a);o++){
			if layer_get_element_type(_a[o]) == layerelementtype_tilemap{
				_id = layer_get_element_layer(_a[o]);
				_r = true;
				break;
			}
		}
		// If so, chop up the name of the parallax layer and apply parallax strength
		if(_r){
			var __r = false;
			for(var n = 0;n<array_length(fx_layers);n++){
				if layer_get_name(_id) == fx_layers[n]{
					__r = true;
					break;
				}
			}
			if (__r){
				with(instance_create(0,0,obj_ShadowContainer)){
					target_layer = _id;
					depth = layer_get_depth(target_layer) - 101;
				}
			}else{
				trace("Layer",layer_get_name(_id),"(",_id,") NOT FOUND!");	
			}
		}
	}
	// ima tire... HHOUOUUUURRRRRRMMPHPHPPHHHH
}
if instance_exists(Player){
	with(instance_create(Player.x,Player.y,obj_Camera)){
		view_object = Player;	
	}
}