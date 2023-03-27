{
	for(var i = 0;i<ds_list_size(MenuItem);i++){
		if is_lq(MenuItem[|i]){
			delete MenuItem[|i];	
		}
	}
	ds_list_destroy(MenuItem);
}