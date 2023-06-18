{
	candie = true;
	collisions = true;
	image_xscale_draw = undefined;
	image_yscale_draw = undefined;
	image_scale = 1;
	image_speed = 0.2;
	animation_mod = random_get_seed();
	coyote_time = current_frame;
	clinging = false;
	hspd_decay_frame = current_frame;
	nexthurt = current_frame;
	image_angle_draw = 0;
	max_hspd = 4;
	max_vspd = 3;
	tumble_frame = 0;
	bounce_frame = 0;
	damage_buffer = -4;
	slide_strength = 0;
	hitstun_timer = 0;
	
	hspd = 0;
	vspd = 0;
	hspd_sub = 0;
	vspd_sub = 0;
	hspd_extra = 0;
	vspd_extra = 0;
	friction = 0.3;
	
	my_health = 4;
	maxhealth = 4;
	team = 0;
	
	moveState = movestate.idle;
	gameState = gamestate.idle;
	
	on_step = undefined;
	has_on_step = undefined;
	
	on_endstep = undefined;
	has_on_endstep = undefined;
	
	on_endstep_post = undefined;
	has_on_endstep_post = undefined;
	
	
	on_draw = undefined;
	has_on_draw = undefined;
	on_hit = undefined;
	has_on_hit = undefined;
	on_destroy = undefined;
	has_on_destroy = undefined;
	has_on_bonk = undefined;
	on_bonk = undefined;
}