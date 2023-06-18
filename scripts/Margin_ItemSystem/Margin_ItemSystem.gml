
// Intention: Write a lightweight system for Margin that utilizes Izzy's item system, 
// while also completely ignoring Izzy's item system.
enum item_cell{
	// Associated with columns from left to right in a spreadsheet
	// Designed so that we can append it as needed -- in particular, we'll probably need to do this for descriptions
	key,
	name,
	description_ling,
	description_nil,
	sprite_icon,
	sprite_pickup,
	sprite_growth,
	growth_time,
	growth_payload,
	item_type,
	item_max,
	item_price,
	item_can_sell,
	item_can_gift
 }
enum itemtype{
	material_waking,
	material_margin,
	key_waking,
	key_margin
}
function EmptyItem() constructor{
	ID = "TestItem";
	name = "MISSINGNO";
	description = {
		ling : "What is that? what IS that?!?!!!!",
		nil : "i think i'm gonna be sick... urp!"
	}
	sprite = {
		icon : PLACEHOLDER_Missingno,
		pickup : WHOOPS_Missingno,
		growth : WHOOPS_Missingno
	}
	growth = {
		time : 1,
		payload : ["TestItem", 80]
	}
	item = {
		type : itemtype.material_margin,
		amount : 0,
		amax : 99,
		can_sell : true,
		can_gift : true
	}
}
function item_margin_init(){
	// Initialize this struct so we can store the inventory items
	global.item_pool = {
		keys : [],        // Pool of all items loaded
		                  // We separately track the below for sorting purposes
		item_waking : [], // Standard items for the waking world
		item_margin : [], // Standard items for Margin
		key_waking : [],  // Key Items for the Waking world
		key_margin : [],  // Key Items for Margin
		item_active : undefined
	}
	
	var csv = load_csv(working_directory + "/data/ItemTable.csv");
	for(var i = 1;i<ds_grid_height(csv);i++){
		var _struct = new EmptyItem();
		_struct.key = csv[#item_cell.key,i];
		_struct.name = csv[#item_cell.name,i];
		_struct.description = {
			ling : csv[#item_cell.description_ling,i],
			nil : csv[#item_cell.description_nil,i]
		}
		// These are all stored as strings. Convert them to resource IDs
		_struct.sprite = {
			icon : csv[#item_cell.sprite_icon,i],
			pickup : csv[#item_cell.sprite_pickup,i],
			growth : csv[#item_cell.sprite_growth,i],
		}
		// Converts all the items into sprites, or sets them to the default value otherwise
		var ar = ["icon","pickup","growth"]
		for(var io = 0;io<array_length(ar);io++){
			var _val = lq_defget(_struct.sprite, ar[io], -1);
			if sprite_exists(asset_get_index(_val)){
				lq_set(_struct.sprite, ar[io], asset_get_index(_val));	
			}else lq_set(_struct.sprite, ar[io], WHOOPS_Missingno);
		}
		
		// Initializes values for the items
		// Note that Amount isn't initialized here because that's a live value based on the save
		_struct.item = {
			type : csv[#item_cell.item_type,i],
			amax : csv[#item_cell.item_max,i],
			price : csv[#item_cell.item_price,i],
			payload : csv[#item_cell.growth_payload,i],
			can_sell : csv[#item_cell.item_can_sell,i],
			can_gift : csv[#item_cell.item_can_gift,i]
		}
		// Fixes all the data types
		var ar = ["type","amax","price","can_sell","can_gift"];
		for(var io = 0;io<array_length(ar);io++){
			var _val = lq_defget(_struct.item, ar[io], "");
			if is_really_real(_val){
				lq_set(_struct.item,ar[io],real(_val));
			}else{
				var _r = 0;
				switch(string_lower(_val)){
					case "false":
						_r = 0; break;
					case "true":
						_r = 1; break;
					case "material": 
						_r = 0; break;
					case "key": 
						_r = 1; break;
					case "material_waking": 
					case "material waking":
					case "waking material":
						_r = 2; break;
					case "key_waking":
					case "key waking":
					case "waking key":
						_r = 3; break;
					default:
						_r = 0;
					break;
				}
				lq_set(_struct.item,ar[io],_r);
			}
		}
		lq_set(global.item_pool,_struct.key,_struct);
		array_push(global.item_pool.keys,_struct.key);
		switch(lq_get(_struct.item,"type")){
			case 0: array_push(global.item_pool.item_margin, _struct.key); break;
			case 1: array_push(global.item_pool.key_margin,_struct.key); break;
			case 2: array_push(global.item_pool.item_waking, _struct.key); break;
			case 3: array_push(global.item_pool.key_waking, _struct.key); break;
		}
		var _file = file_text_open_write(working_directory + "/data/inventory_output.txt");
		var _json = json_stringify(global.item_pool);
		file_text_write_string(_file, _json);
		file_text_close(_file);
	}
	#macro ITEMPOOL global.item_pool
}

function item_get_name(_key){
	var _lq = lq_defget(ITEMPOOL,_key);
	if !is_lq(_lq){
		return "MISSINGNO"	
	}
	return _lq.name;
}
function item_get_description(_key,_type){
	var _lq = lq_defget(ITEMPOOL,_key);
	if !is_lq(_lq){
		return "(...)";	
	}
	return lq_defget(_lq.description,_type,"(...)");
}
function item_get_sprite(_key,_type){
	var _lq = lq_defget(ITEMPOOL,_key);
	if !is_lq(_lq){
		return WHOOPS_Missingno;
	}
	return lq_defget(_lq.sprite,_type,WHOOPS_Missingno);
}
function item_get_value(_key,_type){
	var _lq = lq_defget(ITEMPOOL,_key);
	if !is_lq(_lq){
		return 1;	
	}
	return lq_defget(_lq.item,_type,1);
}
function item_get_amount(_key){
	// This one is SPECIFICALLY for getting item.key.amount, as it's a live value
	var _lq = lq_defget(ITEMPOOL,_key);
	if !is_lq(_lq){
		return 0;
	}
	return lq_defget(_lq.item,"amount",0);
}
function item_set_amount(_key,_value){
	// This one is SPECIFICALLY for setting item.key.amount, as it's a live value
	var _lq = lq_defget(ITEMPOOL,_key);
	if is_lq(_lq){
		lq_set(_lq,_key,_value);
	}
}