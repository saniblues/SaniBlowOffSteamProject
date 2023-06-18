function save_init(){
	global.save = {
		settings : {
			audio : {
				sfx_volume : 1, // Multiplicative
				mus_volume : 1, // Multiplicative
				captioning : 1, // Boolean
			}, 
			gameplay : {
				difficulty : 1,    // Uh?
				temperature : 214, // Measures the temperature, in Fahrenheit
			},
			debug : {
				allow_tracelog : true	
			},
		},
		savedata : {
			item : {
				missingno : new Item("Missingno.", item_text("missingno"), PLACEHOLDER_Missingno, ITEMTYPE.key_item, -1, -1, false, false, 0),
				accelerator : new Item("ACCELERATOR", item_text("item_accelerator"), PLACEHOLDER_Missingno, ITEMTYPE.key_item, -1, -1, false, false, 0),
				wallclaw : new Item("CLIMBING GLOVES", item_text("item_wallclaw"), PLACEHOLDER_Missingno, ITEMTYPE.key_item, -1, -1, false, false, 0),
				doublejump : new Item("SPRING BOOTS", item_text("item_doublejump"), PLACEHOLDER_Missingno, ITEMTYPE.passive, -1, -1, false, false, 0),
				capsulelauncher : new Item("Capsule Launcher", item_text("item_capgun"), PLACEHOLDER_Missingno, ITEMTYPE.weapon, 0, 10, false, false, 0),
			},
			player : {
				hp : 100,
			},
			checkpoint : {
				room : undefined,
				index : undefined,
				x : undefined,
				y : undefined,
			}
		}
	}
	if !file_exists(working_directory + "/save/" + __savefile__) SaveGame();
	#macro SAVE global.save
	#macro SAVEDATA global.save.savedata
	#macro SETTING global.save.settings
	#macro ITEM global.save.savedata.item
	#macro __savefile__ "save0.dat"
}
enum ITEMTYPE{
	passive = -1,
	key_item = 0,
	weapon = 1
}

function SaveGame(_filename){
	// Scan save directory for all file names -- loading does this too, so whatever
	var i = 0;
	var fileName = file_find_first(working_directory + "/save/" + "*.dat",fa_directory);
	while(fileName != ""){
		fArray[i] = fileName;
		fileName = file_find_next();
		i += 1;
	}
	file_find_close();
	
	// If a real number is submitted, creates a savefile save#.dat
	if is_real(_filename){
		_filename = "save" + string(_filename) + ".dat";	
	}
	// Buf it it's undefined, sets its name to the number of files in the directory + 1
	if is_undefined(_filename){
		_filename = "save0.dat";
	}
	var _string = json_stringify(SAVE);
	var file = file_text_open_write(working_directory + "/save/" + _filename);
	file_text_write_string(file, _string);
	file_text_close(file);
	
	trace("GAME SAVED");
}

function LoadGame(_filename){
	if is_undefined(_filename){
		_filename = "save0.dat";	
	}
	if !file_exists(working_directory + "/save/" + _filename){
		_filename = "save0.dat";
		SaveGame(_filename); // Sanity check	
	}else{
		trace("FILE",_filename,"FOUND! LOADING...");	
	}
	var _json = "";
	var file = file_text_open_read(working_directory + "/save/" + _filename);
		do{
			_json += file_text_readln(file);
		}until file_text_eof(file);
	file_text_close(file);
	var _temp = json_parse(_json);
	_temp = variable_struct_null_to_undefined(_temp);
	SAVE = copy_deep(SAVE, _temp);
	
	// Temporary
	schedule_noref(1,function(){
		trace("APPLYING SAVE DATA");
		if !is_undefined(SAVEDATA.checkpoint.room){
			room_goto(SAVEDATA.checkpoint.room);
			trace("GOING TO",room_get_name(SAVEDATA.checkpoint.room));
			schedule_noref(2,function(){
					with(Player){
						x = SAVEDATA.checkpoint.x;
						y = SAVEDATA.checkpoint.y;
					}
					with(obj_Camera){
						x = Player.x;
						y = Player.y;
						view_object = Player;
						view_anchor = -4;
					}
				}
			);
		}else{
			trace(SAVEDATA.checkpoint.room);	
		}
	});
}

function item_text(_key){
	var _string = "It- It's beautiful...";
	switch(_key){
		case "item_accelerator":
			_string = "Forbidden Technology\nDash Jump to gain infinite speed";
			break;
		case "item_wallclaw":
			_string = "A reliable pair of climbing gloves\nPress towards a wall to cling to it";
			break;
		case "item_springboots":
			_string = "Novakin©-brand Air Walkers\nEnables Doublejumping\nKick off the day in Style";
			break;
		case "item_capgun":
			_string = "A Breech-Loaded Capsule Launcher\nLoaded with Frost Capsules";
			break;
	}
	return _string;
}
function Item(_DisplayName, _DisplayText, _DisplaySprite, _ItemType, _Ammo, _MaxAmmo, _Mode, _Unlocked, _Enabled) constructor{
	name = _DisplayName;
	text = _DisplayText;
	spr_HUD = _DisplaySprite;
	type = _ItemType;
	ammo = _Ammo;
	ammo_max = _MaxAmmo;
	mode = _Mode;
	
	unlocked = _Unlocked;
	enabled = _Enabled;
}