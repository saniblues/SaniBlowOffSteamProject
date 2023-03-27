enum movestate{
	idle,
	walk,
	hurt,
	jump,
	jump_charge,
	doublejump,
	doublejump_landing,
	tumble,
	angyjump,
	dropkick,
	fall,
	crouch,
	slide,
	knockout,
	hitstun,
	bonk,
	freefall,
	wallcling
}
enum gamestate{
	idle,
	crouch,
	jump_attack,
	hitstun,
	knockout
}