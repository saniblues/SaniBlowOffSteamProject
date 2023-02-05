{
	candie = true;
	collisions = true;
	image_scale = 1;
	image_speed = 0.2;
	animation_mod = random_get_seed();
	coyote_time = current_frame;
	clinging = false;
	hspd_decay_frame = current_frame;

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
	
	moveState = movestate.idle;
	gameState = gamestate.idle;
	
	on_step = undefined;
	has_on_step = undefined;
	on_draw = undefined;
	has_on_draw = undefined;
	on_hit = undefined;
	has_on_hit = undefined;
	on_destroy = undefined;
	has_on_destroy = undefined;
	has_on_bonk = undefined;
	on_bonk = undefined;
}