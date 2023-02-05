{
	// Subpixel handler
	var _hspd_final, _vspd_final;
	
	hspd_sub += hspd;
	vspd_sub += vspd;
	_hspd_final = round(hspd_sub);
	_vspd_final = round(vspd_sub);
	hspd_sub -= _hspd_final;
	vspd_sub -= _vspd_final;

	for (i = 0; i < abs(_hspd_final); ++i) {
		x += sign(hspd);
	}
	for(var i = 0;i< abs(_vspd_final); ++i){
		y += sign(vspd);	
	}
}