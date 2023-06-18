function schedule(_timer, _function){
	schedule_pass(_timer, _function, -1); 
}
function schedule_noref(_timer, _function){
	schedule_pass_noref(_timer, _function, -1); 
}
function schedule_pass(_timer, _function, _passthrough){
	with(UberCont){
		ds_list_add(schedule_queue, {source : other, timer : _timer, func : _function, passthrough : _passthrough});	
	}
}
function schedule_pass_noref(_timer, _function, _passthrough){
	with(UberCont){
		ds_list_add(schedule_queue, {source : UberCont, timer : _timer, func : _function, passthrough : _passthrough});	
	}
}