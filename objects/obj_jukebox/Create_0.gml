//tocando a musica
//audio_play_sound(snd_summer, 0, true);

//a jukebox é um emitter de som
s_emit = audio_emitter_create();

//definindo a posição do emitter
audio_emitter_position(s_emit, x, y, 0)

//tocando a musica
audio_play_sound_at(snd_summer, x, y, 0, 100, 300, 1, true, 1)