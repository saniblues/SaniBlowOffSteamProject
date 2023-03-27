if is_undefined(has_on_endstep){
	try{
		on_endstep();
		has_on_endstep = true;
	}catch(_error){
		has_on_endstep = false;	
	}
}else{
	if (has_on_endstep){
		on_endstep();	
	}
}
	
// Actual collision checks + movement
var i;
var _hspd_plus = 0;
var _vspd_plus = 0;
var _hspd_final = hspd, _vspd_final = vspd;
	
// Adds speed from moving objects
var sign_vspd = sign(vspd) == 0 ? 1 : sign(vspd);
if (place_meeting(x, y + (6 * sign_vspd), MovingCollisionObject)){
	with(instance_place(x, y + (6 * sign_vspd), MovingCollisionObject)){
		_hspd_plus = hspd;
		_vspd_plus = vspd;
	}
}
/*
// Subpixel handler
hspd_sub += hspd;
vspd_sub += vspd;
_hspd_final = round(hspd_sub);
_vspd_final = round(vspd_sub);
hspd_sub -= _hspd_final;
vspd_sub -= _vspd_final;
*/
_vspd_final += _vspd_plus;
_hspd_final += _hspd_plus;
if place_meeting(x,y+_vspd_final,par_CollisionObject) || _vspd_final >= 16{
	for (i = 0; i < abs(_vspd_final); ++i) {
	    if (!place_meeting(x, y + sign(_vspd_final), par_CollisionObject))
	        y += sign(_vspd_final);
	    else {
	        vspd = 0;
	        break;
	    }
	}
}else y += _vspd_final;


// Horizontal
var _hspd_final = hspd + _hspd_plus;
if place_meeting(x + _hspd_final, y, par_CollisionObject) || _hspd_final >= 16
{
	for (i = 0; i < abs(_hspd_final); ++i) {
	    if (moveState != movestate.wallcling){
			var _r = false;
			// UP slope
		    if (place_meeting(x + sign(_hspd_final), y, par_CollisionObject) && !place_meeting(x + sign(_hspd_final), y - 1, par_CollisionObject)){
		        _r = true;
				--y;
			}
		    // DOWN slope
		    if (!place_meeting(x + sign(_hspd_final), y, par_CollisionObject) && !place_meeting(x + sign(_hspd_final), y + 1, par_CollisionObject) && place_meeting(x + sign(hspd), y + 2, par_CollisionObject)){
		        _r = true;
				++y;      
			}
			// Slow you down when moving up or down a slope
			_r = false;
			if (_r){
				if !batch_compare(moveState,movestate.slide){
					hspd *= 0.95;
					_hspd_final = hspd + _hspd_plus;
				}else{
					hspd *= 0.98;
					_hspd_final = hspd + _hspd_plus;
				}
			}
		}
	
	    if (!place_meeting(x + sign(_hspd_final), y, par_CollisionObject))
	        x += sign(_hspd_final); 
	    else {
	        // Push block
	        /*if (place_meeting(x + sign(hspd), y, oPushBlock)) {
	            with (instance_place(x + sign(hspd), y, oPushBlock))
	                hspd = other.hspd
	        } else
			*/
			if abs(hspd) < 8{
	            hspd = 0;
			}else{
				if is_undefined(has_on_bonk){
					try{
						on_bonk();	
						has_on_bonk = true;
					}catch(_error){
						has_on_bonk = false;
					}
				}
				if (has_on_bonk){
					on_bonk();	
				}else hspd = 0;
			}
	        break;
	    }
	}
}else x += _hspd_final;

if hspd_decay_frame <= current_frame{
	var _prev = sign(hspd);
	
	var _slide_factor = (batch_compare(moveState,movestate.hitstun,movestate.bonk) ? 8 : (moveState == movestate.slide ? 16 : 1));
	if tumble_frame < current_frame - 60{
		hspd -= (friction * sign(hspd)) / _slide_factor;
	}
	
	if (sign(hspd) != _prev){
		hspd = 0;	
	}
	hspd_extra -= (friction / 2) / _slide_factor;
	if hspd_extra <= 0{
		hspd_extra = 0;	
	}
	vspd_extra -= (friction/2) / _slide_factor;
	if vspd_extra <= 0{
		vspd_extra = 0;	
	}
	
	if is_undefined(has_on_endstep_post){
		try{
			on_endstep_post();
			has_on_endstep_post = true;
		}catch(_error){
			has_on_endstep_post = false;	
		}
	}else{
		if (has_on_endstep_post){
			on_endstep_post();	
		}
	}
}