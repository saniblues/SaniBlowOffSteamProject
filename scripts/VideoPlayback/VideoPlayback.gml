// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function video_playback_init(){
	global.video = {
		loaded : false,
		duration : -1, 
		loop : false,
		pause : false,
		fullscreen : false,
		param : {
			width : game_width,
			height : game_height,
			x : undefined,
			y : undefined
		}
	}
}

#macro VIDEO global.video

function video_setup(_path){
	video_setup_ext(_path, false, undefined, undefined);	
}
function video_setup_fullscreen(_path){
	if !file_exists(_path){
		trace("Video does not exist at",_path,"! Please check your spelling...");
		exit;
	}
	video_close();
	VIDEO.loaded = false;
	VIDEO.fullscreen = true;
	with(instance_create(0,0,par_VideoContainer)){
		video_open(_path);
	}
	VIDEO.duration = video_get_duration();
	VIDEO.loop = false;
}
function video_setup_ext(_path, _loop, _x, _y){
	if !file_exists(_path){
		trace("Video does not exist at",_path,"! Please check your spelling...");
		exit;
	}
	
	VIDEO.loaded = false;
	VIDEO.param.x = _x;
	VIDEO.param.y = _y;
	with(instance_create(0,0,par_VideoContainer)){
		video_open(_path);
	}
	VIDEO.duration = video_get_duration();
	VIDEO.loop = false;
}