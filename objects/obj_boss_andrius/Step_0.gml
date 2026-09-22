if(global.pause == false){
	script_execute(estado);
	image_xscale = 0.5;
	image_yscale = 0.5;
	//scr_movimento_senoidal(room_width / 2, room_height / 2, 35, 0.05);
    
    comecou_luta = true;
    
if (vida <= 0) {
        var _drop_x = x - 10;
        var _drop_y = y + 10;

        global.inimigos_mortos += 1;
        gc_game_state_sync_from_legacy();

        gc_quest_notify("matar", "andrius", 1);
        gc_quest_notify("matar", "inimigo", 1);
        gc_state_flag_set("andrius_derrotado", true);

        audio_pause_sound(snd_andrius_batalha);

        with (obj_minion_andrius_1) instance_destroy();
        with (obj_numeros) instance_destroy();
        with (obj_boss_andrius_ataque_2) instance_destroy();
        with (obj_boss_andrius_projetil) instance_destroy();

        var _layer = layer_get_id("sequences");
        if (_layer != -1) {
            layer_sequence_create(_layer, 0, 0, sq_andrius_defeat);
        }

        setar_camera();
        drop_moedas(_drop_x, _drop_y, 50, 100);

        instance_destroy();
        exit;
    }
}
