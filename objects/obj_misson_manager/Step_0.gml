if instance_exists(obj_sdash){
	if (!obj_sdash.active) instance_destroy();
		function apply_rewards(_rewards) {
		    global.player_stats.gold += _rewards.gold;
		    global.player_stats.gems += _rewards.gems;
		}

		// Verifica e limita uma missão ativa por vez
		var _active_count = 0;
		for (var i = 0; i < array_length(global.missions); i++) {
		    if (global.missions[i].status == "active") _active_count++;
		    if (_active_count > 1) {
		        global.missions[i].status = "inactive"; // Desativa missões extras
		    }
		}

		// Verifica progresso da missão 1
		if (global.missions[0].status == "active" && global.missions[0].progress[0] >= global.missions[0].target && !global.dialogo_acontecendo) {
		    global.missions[0].status = "completed";
		    apply_rewards(global.missions[0].rewards);
			 global.dialogo_acontecendo = true;
		    var _dialogo = instance_create_layer(0, 0, "Dialogo", obj_dialogo);
		    _dialogo.npc_nome = "Missao_Concluida";
		}

		// Verifica progresso da missão 2
		if (global.missions[1].status == "active" && global.missions[1].progress[1] >= global.missions[1].targets[1] && !global.dialogo_acontecendo) {
		    global.missions[1].status = "completed";
		    apply_rewards(global.missions[1].rewards);
		    global.dialogo_acontecendo = true;
		    var _dialogo = instance_create_layer(0, 0, "Dialogo", obj_dialogo);
		    _dialogo.npc_nome = "Missao2_Concluida";
		}

		// Alterna menu com tecla M
		if (keyboard_check_pressed(ord("M")) && !global.dialogo_acontecendo) {
		    show_menu = !show_menu;
		    bg_alpha = show_menu ? 0 : 1; // Reseta alpha
		}
}