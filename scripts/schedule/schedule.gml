function schedule(_timer, _function){
	schedule_pass(_timer, _function, -1); 
}
function schedule_pass(_timer, _function, _passthrough){
	with(UberCont){
		ds_list_add(schedule_queue, {source : other.id, timer : _timer, func : _function, passthrough : _passthrough});	
	}
}