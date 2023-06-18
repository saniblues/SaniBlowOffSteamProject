{
	speed_init();
	gravity_strength = 1; // I just know this needs to be a big number
	rope_length = 48;
	joint_num = 4;
	joint_distance = rope_length / joint_num;
	joint_iterations = 3;
	joint_constraint = 30;
	joint = [];
	
	anchor = -4;
	anchored = -4;
	anchored = Player;
	
	Joint = function() constructor{
		x = other.x + random_range(-2,2);
		y = other.y + random_range(-2,2);
		xprevious = x;
		yprevious = y;
		target = -4;
		target_angle_offset = 0;
	}
	alarm[0] = 1;
}