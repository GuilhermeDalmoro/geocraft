/// @description Iniciando as variaveis
if (!variable_global_exists("volume_sfx")) global.volume_sfx = 1;
if (!variable_global_exists("volume_musica")) global.volume_musica = 1;
if (!variable_global_exists("volume_mestre")) global.volume_mestre = 1;

if (file_exists("config.ini")) {
    ini_open("config.ini");
    global.volume_mestre = clamp(ini_read_real("audio", "volume", global.volume_mestre), 0, 1);
    ini_close();
}

audio_master_gain(global.volume_mestre);


audio_controller = new audio_controle("volume_sfx", "volume_musica", "volume_mestre");

sfx_moeda = new tocar_audio_unico(snd_pickup_coin_1, AU_TIPO_SFX);

sfx_dash = new tocar_audio_unico(snd_dash, AU_TIPO_SFX);

sfx_blip = new tocar_audio_unico(snd_blip_select, AU_TIPO_SFX)

sfx_gmd_dano = new tocar_audio_unico(snd_gmd_dano, AU_TIPO_SFX)

sfx_explosao = new tocar_audio_unico(snd_explosion, AU_TIPO_SFX)

sfx_tiro = new tocar_audio_unico(snd_tiro, AU_TIPO_SFX)

sfx_andrius_defeat = new tocar_audio_unico(snd_andrius_defeat, AU_TIPO_SFX)

//sfx_golpe_picareta_madeira = new tocar_audio_unico(snd_picareta_madeira, AU_TIPO_SFX);

//sfx_golpe_normal_sdash = new tocar_audio_unico(snd_golpe_sdash, AU_TIPO_SFX)

//sfx_sdash_dano = new tocar_audio_unico(snd_sdash_dano, AU_TIPO_SFX)

msc_theme_room1 = new tocar_audio_loop(snd_music_other, AU_TIPO_MUSICA, 2000)

msc_theme_menu = new tocar_audio_loop(snd_menu, AU_TIPO_MUSICA, 2000)

msc_theme_summer = new tocar_audio_loop(snd_summer, AU_TIPO_MUSICA, 2000)

sfx_andrius_battle = new tocar_audio_unico(snd_andrius_batalha, AU_TIPO_MUSICA, 2000)