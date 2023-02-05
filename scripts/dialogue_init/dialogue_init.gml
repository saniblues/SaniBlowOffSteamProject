// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
enum diag{
	key,               // Searchable key
	name,              // Display name
	portrait,          // Display Portrait(?)
	sound,             // Text sound
	text,              // The actual text
	terminate,         // Don't continue scanning from here
	question,          // Is it a question?
	option,            // Option display name
	goto,              // Jump to dialogue
	avail,             // Availability check (Assumed True)(Used for Questions and normal Dialogues keys)
	redirect,          // (Dialogue Keys only) Jump to this option when above check is false
	command_prefix,    // Run this command when the dialogue starts
	command_postfix    // Run this command when the dialogue ends
}
function dialogue_init(){
	global.dialogue_map = ds_map_create();
	global.dialogue_map[? "HelloWorld"] = 
		[
			"HelloWorld",
			"Emilia",
			-1,
			sndDevTest,
			":33 < hey hey hey!\n:33 < smoke w33d efurry day!",
			true,
			false,
			false,
			-1,
			true,
			-1,
			-1,
			-1
		];
	global.dialogue_map[? "HelloWorld_GoingDown"] = 
		[
			"HelloWorld",
			"Emilia",
			-1,
			sndDevTest,
			":33 < going meown!",
			true,
			false,
			false,
			-1,
			true,
			-1,
			-1,
			-1
		];
	global.dialogue_map[? "AcceleratorToggle"] = 
		[
			"HelloWorld",
			"Emilia",
			-1,
			sndDevTest,
			":33 < accelerator enyaabled\n:33 < hold up at the end of any jump\n:33 < to nyoooooooooooom",
			true,
			false,
			false,
			-1,
			true,
			-1,
			-1,
			-1
		];
}
function dialogue_get_text(_key){
	if !is_undefined(global.dialogue_map[? _key]){
		return global.dialogue_map[? _key][diag.text];	
	}
}
function say(_key){
	with(instance_create(x,bbox_top - sprite_height * 2,obj_WordBubble)){
		text = dialogue_get_text(_key);	
		return id;
	}
}