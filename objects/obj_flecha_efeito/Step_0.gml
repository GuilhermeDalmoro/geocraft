image_alpha -= 0.1;
if image_alpha <= 0 {
	audio_play_sound(snd_dash,5,false,1,5.90);
   instance_destroy();
}