{
	// Check to see if the player is in a neutral state
	if !batch_compare(other.moveState, movestate.idle,movestate.walk,movestate.crouch,movestate.jump_charge,movestate.doublejump_landing){
		exit;	
	}
	// Check to make sure that an appropriate checkpoint exists.
	   // If it doesn't, there's no point in doing any of this
	var _inst = -4;
	with(map_Checkpoint){
		if image_index == other.image_index{
			_inst = id;
			break;
		}
	}
	if !instance_exists(_inst) exit;
	
	var _Checkpoint = SAVEDATA.checkpoint;
	if _Checkpoint.room != room || _Checkpoint.index != image_index{
		_Checkpoint.room = room;
		_Checkpoint.index = image_index;
		_Checkpoint.x = _inst.x + 8;
		_Checkpoint.y = _inst.y + 8;
		
		SaveGame();
	}
}