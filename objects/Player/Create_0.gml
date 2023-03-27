{
	event_inherited();
	cling_direction = 1;
	wallcling_frame = current_frame;
	wallcling_button = KEY_START;
	max_vspd = 3;
	max_hspd = 4;
	accelerator_enabled = false; // Temporary
	tumble_frame = 0;
	team = 1;
	friction = 0.2;
	// Player-specific functions
	bounce_particles = function(){
		var i = -1;
		repeat(2){
			with(instance_create(x,bbox_bottom,par_Effect)){
				direction = 90 + (90 * i);
				speed = 5;
				friction = 0.66;
			}
			i = 1;
		}
		repeat(3){
			with(instance_create(x,bbox_bottom,par_Effect)){
				direction = 90 + choose(-60,60) + random_range(-10,10);
				speed = random_range(3,4.5);
				image_speed += random_range(-0.3,0.1);
				friction = 0.66;
			}	
		}	
	}
	doublejump_bounce = function(){
		bounce_particles();
		moveState = movestate.doublejump_landing;
		audio_play_sound(bounce_2,0,0,0.7);
		vspd = -1;
		if !place_meeting(x,y-1,par_CollisionObject){
			y --;
		}
		coyote_time = current_frame + 100;
	}
	has_on_bonk = true;
	on_bonk = function(){
		if abs(hspd) >= 8{
			with(instance_place(x + hspd, y + vspd, par_CollisionObject)){
				if(destructible){
					chain_destroy(chain_destroy_array);	
				}
			}
		}
		hspd = hspd * -0.33;
		hspd = -sign(hspd);
		hspd_extra = 0;
		vspd_extra = 0;
		vspd = -2;
		moveState = movestate.bonk;
		hitstun_timer = 30;
		audio_play_sound(Bounce,1,0,0.7);	
	}
	/*
	with(script_bind()){
		creator = other.id;
		sprite_index = other.mask_index;
		on_step = function(){
			trace("HELLO WORLD", current_frame);	
		}
		
		on_draw = function(){
			if !instance_exists(creator){
				instance_destroy();
				exit;
			}
			x = creator.x;y=creator.y;
			speed=creator.speed;direction=creator.direction;
			draw_sprite(sprite_index,image_index,x,y);
		}
	}
	*/
	/*
	with(script_bind()){
		creator = other.id;
		on_draw = function(){
			if !instance_exists(creator){
				instance_destroy();
				exit;
			}
			x = creator.x;
			y = creator.bbox_top;
			draw_set_font(fntChat);
			draw_text(x,y,string(creator.vspd) + "+\n" + string(creator.moveState) + "(" + string(movestate.doublejump_landing) + ")");
		}
	}
	*/
}