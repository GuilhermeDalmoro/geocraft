function scr_screen_shake(_val1, _val2){
	///@arg força do shake
	///@arg tempo do shake	
	
	with(camera_sdash){
	shake_forca = _val1;
	shake_temp  = _val2;
	alarm[0] = shake_temp;
	}
}