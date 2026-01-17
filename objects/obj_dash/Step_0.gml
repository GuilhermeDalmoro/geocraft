image_alpha -= 0.1;
if image_alpha <= 0 {
	//audio_play_sound(snd_dash,1,false,1,5.90);
    obj_som.sfx_dash.play = true
   instance_destroy();
}