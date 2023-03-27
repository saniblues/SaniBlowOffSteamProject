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
					
				visible = true;
			}
		}
	}
}
layer_set_visible(source_layer,false);

if instance_exists(Player){
	with(instance_create(Player.x,Player.y,obj_Camera)){
		view_object = Player;	
	}
}