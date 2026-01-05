/// @description Iniciando as variaveis
global.volume_sfx = 1;
global.volume_musica = 1;
global.volume_mestre = 1;


audio_controller = new audio_controle("volume_sfx", "volume_musica", "volume_mestre");

sfx_moeda = new tocar_audio_unico(snd_pickup_coin_1, AU_TIPO_SFX);

//sfx_golpe_picareta_madeira = new tocar_audio_unico(snd_picareta_madeira, AU_TIPO_SFX);

//sfx_golpe_normal_sdash = new tocar_audio_unico(snd_golpe_sdash, AU_TIPO_SFX)

//sfx_sdash_dano = new tocar_audio_unico(snd_sdash_dano, AU_TIPO_SFX)

msc_theme_room1 = new tocar_audio_loop(snd_music_other, AU_TIPO_MUSICA, 2000)

msc_theme_menu = new tocar_audio_loop(snd_menu, AU_TIPO_MUSICA, 2000)
