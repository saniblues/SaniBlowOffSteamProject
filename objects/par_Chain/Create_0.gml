{
	speed_init();
	xstart_spd = 0;
	ystart_spd = 0;
	depth ++;
	gravity_strength = 1; // I just know this needs to be a big number
	rope_length = 64;
	joint_num = 6;
	joint_distance = rope_length / joint_num;
	joint_iterations = 3;
	joint_constraint = 30;
	joint = [];
	
	anchor = -4;
	anchored = -4;
	randomize();
	rand = random_get_seed();
	on_pick = function(_id){
		if !instance_exists(anchored){
			anchored = _id;
		}else{
			_aprev = anchored;
			if instance_is(anchored,par_Hitme){
				anchored.vspd = -4;
				anchored.hspd += hspd / 2;
				anchored.moveState = movestate.jump;
				vspd -= 4;
				hspd *= -0.80;
			}
			anchored = -4;
			if _aprev != _id{
				anchored = _id;	
			}
		}
		if instance_exists(anchored){
			vspd = anchored.vspd;
			hspd = anchored.hspd;
		}
	}
	Joint = function() constructor{
		x = other.x + random_range(-2,2);
		y = other.y + random_range(-2,2);
		xprevious = x;
		yprevious = y;
		target = -4;
		target_angle_offset = 0;
	}
	repeat(16){
		ystart--;
		if collision_point(x,ystart,par_CollisionObject,1,1){
			y++;
			break;
		}
	}
	alarm[0] = 1;
}