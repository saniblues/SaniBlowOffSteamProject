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
			}
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
	if !file_exists(__savefile__) SaveGame();
	#macro SAVE global.save
	#macro SAVEDATA global.save.savedata
	#macro SETTING global.save.settings
	#macro ITEM global.save.savedata.item
	#macro __savefile__ "save.txt"
}
enum ITEMTYPE{
	passive = -1,
	key_item = 0,
	weapon = 1
}

function SaveGame(){
	var _string = json_stringify(SAVE);
	var file = file_text_open_write(__savefile__);
	file_text_write_string(file, _string);
	file_text_close(file);
	
	trace("GAME SAVED");
}

function LoadGame(){
	if !file_exists(__savefile__){
		SaveGame(); // Sanity check	
	}
	var _json = "";
	var file = file_text_open_read(__savefile__);
		do{
			_json += file_text_readln(file);
		}until file_text_eof(file);
	file_text_close(file);
	
	var _temp = json_parse(_json);
	_temp = variable_struct_null_to_undefined(_temp);
	SAVE = copy_deep(SAVE, _temp);
	
	// Temporary
	schedule(1,function(){
		if !is_undefined(SAVEDATA.checkpoint.room){
			room_goto(SAVEDATA.checkpoint.room);
			schedule(2,function(){
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
			}
		}
	);
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