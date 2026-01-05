function scr_ataques_boss(_boss, _ataque_id, _fase, _timer) {
    if (!instance_exists(_boss)) {
        show_debug_message("Erro: Boss não existe!");
        return;
    }
    switch (_ataque_id) {
        case "onda_basica":
            if (_fase == 0) {
                if (_timer == 1) {
                    var _dialogo = instance_create_layer(0, 0, "Instances", obj_dialogo);
                    _dialogo.npc_nome = "ataque_onda_basica_intro";
                    _dialogo.ativo = true;
                }
                if (_timer >= 60) {
                    _boss.fase_ataque = 1;
                    _boss.ataque_timer = 0;
                }
            } else if (_fase == 1) {
                if (_timer == 1) {
                    for (var i = 0; i < 5; i++) {
                        var _proj = instance_create_depth(700, 260 + i * 40 - 80, -1, obj_projetil_batalha);
                        _proj.dano = 4;
                        _proj.hspeed = -5;
                        _proj.desaparecer = true;
                    }
                    var _dialogo = instance_create_layer(0, 0, "Instances", obj_dialogo);
                    _dialogo.npc_nome = "ataque_onda_basica";
                    _dialogo.ativo = true;
                }
                if (_timer >= 120) {
                    _boss.fase_ataque = 2;
                    _boss.ataque_timer = 0;
                }
            } else if (_fase == 2) {
                if (_timer == 1) {
                    var _dialogo = instance_create_layer(0, 0, "Instances", obj_dialogo);
                    _dialogo.npc_nome= "ataque_onda_basica_fim";
                    _dialogo.ativo = true;
                }
                if (_timer >= 60) {
                    global.turno = 0;
                    global.batalha_menu = 0;
                    _boss.fase_ataque = 0;
                    _boss.ataque_timer = 0;
                }
            }
            break;
        case "geometry_dash": // Estilo Geometry Dash
            if (_fase == 0) {
                if (_timer == 1) {
                    var _dialogo = instance_create_layer(0, 0, "Instances", obj_dialogo);
                    _dialogo.npc_nome = "ataque_geometry_dash_intro";
                    _dialogo.ativo = true;
                }
                if (_timer >= 60) {
                    _boss.fase_ataque = 1;
                    _boss.ataque_timer = 0;
                }
            } else if (_fase == 1) {
                if (_timer mod 30 == 0) {
                    var _obstaculo = instance_create_depth(700, 260, -1, obj_projetil_batalha);
                    _obstaculo.dano = 5;
                   _obstaculo.hspeed = 6;
                    _obstaculo.sprite_index = spr_espinho_turno; // Cubo com espinhos
					_obstaculo.direction = obj_sdash_icon;
					//_obstaculo.
                    _obstaculo.desaparecer = true;
                }
                if (_timer >= 180) {
                    _boss.fase_ataque = 2;
                    _boss.ataque_timer = 0;
                }
            } else if (_fase == 2) {
                if (_timer == 1) {
                    var _dialogo = instance_create_layer(0, 0, "Instances", obj_dialogo);
                    _dialogo.npc_nome = "ataque_geometry_dash_fim";
                    _dialogo.ativo = true;
                }
                if (_timer >= 60) {
                    global.turno = 0;
                    global.batalha_menu = 0;
                    _boss.fase_ataque = 0;
                    _boss.ataque_timer = 0;
                }
            }
            break;
        case "hotline_miami": // Estilo Hotline Miami
            if (_fase == 0) {
                if (_timer == 1) {
                    var _dialogo = instance_create_layer(0, 0, "Instances", obj_dialogo);
                    _dialogo.npc_nome = "ataque_hotline_miami_intro";
                    _dialogo.ativo = true;
                }
                if (_timer >= 60) {
                    _boss.fase_ataque = 1;
                    _boss.ataque_timer = 0;
                }
            } else if (_fase == 1) {
                if (_timer mod 20 == 0) {
                    var _inimigo = instance_create_depth(700, random_range(200, 320), -1, obj_projetil_batalha);
                    _inimigo.dano = 3;
                    _inimigo.hspeed = -4;
                    _inimigo.vspeed = random_range(-2, 2);
                    _inimigo.sprite_index = spr_sdash_morte; // Inimigo pequeno
					_inimigo.image_blend = c_red
                    _inimigo.desaparecer = true;
                }
                if (_timer >= 150) {
                    _boss.fase_ataque = 2;
                    _boss.ataque_timer = 0;
                }
            } else if (_fase == 2) {
                if (_timer == 1) {
                    var _dialogo = instance_create_layer(0, 0, "Instances", obj_dialogo);
                    _dialogo.npc_nome = "ataque_hotline_miami_fim";
                    _dialogo.ativo = true;
                }
                if (_timer >= 60) {
                    global.turno = 0;
                    global.batalha_menu = 0;
                    _boss.fase_ataque = 0;
                    _boss.ataque_timer = 0;
                }
            }
            break;
    }
}