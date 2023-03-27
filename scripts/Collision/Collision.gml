function pixel_collision(){
	// Vertical
	if place_meeting(x, y+vspd,par_CollisionObject) || vspd >= 16{
		for(var i = 0;i<abs(vspd);++i){
			if place_meeting(x, y + sign(vspd), par_CollisionObject){
				vspd = 0;
				break;
			}else y += sign(vspd);
		}
	}else y += vspd;
	if place_meeting(x+hspd,y,par_CollisionObject) || hspd >= 16{
		for(var i = 0;i<abs(hspd);++i){
			if place_meeting(x + sign(hspd), y, par_CollisionObject) && !place_meeting(x + sign(hspd), y - 1, par_CollisionObject){
				--y;	
			}
			if !place_meeting(x + sign(hspd), y, par_CollisionObject) && !place_meeting(x + sign(hspd), y + 1, par_CollisionObject) && place_meeting(x + sign(hspd), y + 2, par_CollisionObject){
				++y;	
			}
			if place_meeting(x + sign(hspd), y, par_CollisionObject){
				hspd = 0;	
				break;
			}else x += sign(hspd);
		}
	}else x += hspd;
	/*
	// Actual collision checks + movement
	var i;

	// Vertical
	for (i = 0; i < abs(v); ++i) {
	    if (!place_meeting(x, y + sign(v), oParSolid))
	        y += sign(v);
	    else {
	        v = 0;
	        break;
	    }
	}

	// Horizontal
	for (i = 0; i < abs(h); ++i) {
	    // UP slope
	    if (place_meeting(x + sign(h), y, oParSolid) && !place_meeting(x + sign(h), y - 1, oParSolid))
	        --y;
    
	    // DOWN slope
	    if (!place_meeting(x + sign(h), y, oParSolid) && !place_meeting(x + sign(h), y + 1, oParSolid) && place_meeting(x + sign(h), y + 2, oParSolid))
	        ++y;      
        
	    if (!place_meeting(x + sign(h), y, oParSolid))
	        x += sign(h); 
	    else {
	        // Push block
	        if (place_meeting(x + sign(h), y, oPushBlock)) {
	            with (instance_place(x + sign(h), y, oPushBlock))
	                h = other.h
	        } else
	            h = 0;
	        break;
	    }
	}
	*/	
}

function pixel_collision_old(){
	if place_meeting(x + lengthdir_x(speed,direction), y + lengthdir_y(speed, direction), par_CollisionObject){
		//*
		var _soft = false, _x = undefined, _y = undefined, _kb = undefined;
		var _dir = -direction, _spd = speed;
		var _xp = xprevious, _yp = yprevious;
		var scan_max = 2;
		// Vertical collision
		// It's mostly a copypaste so I'm not gonna bother commenting the stuff below
		if place_meeting(x, y + vspd, par_CollisionObject){// || place_meeting(x,y,par_CollisionObject){
			//vspd /= 2;
			var _r = 0;
			for(var i = 1;i<=scan_max;i++){
				for(var o = 1;o>=-1;o-=2){
					if !place_meeting(x + (i * o), y + vspd, par_CollisionObject){// && place_meeting(x - (i * o), y + vspd, par_CollisionObject){
						x += (i * o);
						y += sign(vspd);
						_r = 1;
						break;
					}
				}
				if (_r) break;
			}
			/*
			for(var i = -5;i<=5;i++){
				if i != 0{
					if !(place_meeting(x + i, y + vspd, par_CollisionObject)) && place_meeting(x - i, y + vspd, par_CollisionObject){
						x += i;
						y += sign(vspd);
						_r = 1;
						break;
					}
				}
			}
			*/
			
			if !(_r){
				//y = yprevious;
				vspd /= 2;
			}else{
				y = round(y);	
			}
			if (place_meeting(x, y + vspd, par_CollisionObject)){
				vspd = 0;
				y = round(y);
			}
		}
	
		// Horizontal collision
		if place_meeting(x + hspd, y, par_CollisionObject){// || place_meeting(x,y,par_CollisionObject){
			// Checks to see if it's a softbody collision or hardbody collision
			// If it's a softbody collision, it pushes them away. Otherwise, it'll treat it like a wall
			//x = xprevious;
			//hspd /= 2;
			var _r = 0;
			for(var i = 1;i<=scan_max;i++){
				for(var o = -3;o<=3;o+=2){
					if !place_meeting(x + hspd, y + (i * o), par_CollisionObject) && place_meeting(x + hspd, y - (i * o), par_CollisionObject){
						y += (i * o);
						x += sign(hspd);
						_r = 1;
						break;
					}
				}
				if (_r) break;
			}
			/*
			for(var i = -5;i<=5;i++){
				if i != 0{
					if !(place_meeting(x + hspd, y + i, par_CollisionObject)) && place_meeting(x + hspd, y - i, par_CollisionObject){
						y += i;
						x += sign(hspd);
						_r = 1;
						break;
					}
				}
			}
			*/
			if !(_r){
				//x = xprevious;
				hspd /= 2;
			}else{
				x = round(x);	
			}
			if (place_meeting(x + hspd, y, par_CollisionObject)){
				hspd = 0;
				x = round(x);
			}
		}
		
		// Sanity check
		if place_meeting(x,y,par_CollisionObject){
			x = round(_xp);
			y = round(_yp);
			xprevious = x;
			yprevious = y;
		}
		//*/
	}
}