{
	if !ds_exists(MenuItem, ds_type_list) exit;
	for(var i = 0;i<ds_list_size(MenuItem);i++){
		if is_lq(MenuItem[|i]){
			delete MenuItem[|i];	
		}
	}
	ds_list_destroy(MenuItem);
	if menu_get() == id{
		menu_prune();	
	}
}