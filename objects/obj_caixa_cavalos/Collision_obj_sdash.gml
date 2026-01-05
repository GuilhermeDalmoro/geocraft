if (global.missions[1].status == "active" && place_meeting(x, y, obj_sdash) && keyboard_check_pressed(ord("I")) && !has_grass) {
    if (global.missions[1].progress[0] > 0) { // Verifica se tem capim coletado
        global.missions[1].progress[0] -= 1; // Remove um capim do contador
        global.missions[1].progress[1] += 1; // Adiciona uma caixa cheia
        has_grass = true; // Marca a caixa como cheia
      //  audio_play_sound(snd_deposit, 1, false); // Adicione som, se tiver
        
        // Visual do capim na caixa
        var _capim = instance_create_layer(x, y, "Instances", obj_capim_visual);
        _capim.image_xscale = 0.5; // Reduz 50%
        _capim.image_yscale = 0.5;
        _capim.depth = depth - 1; // Fica na frente da caixa
		global.cabalos_alimentados += 1;
    }
}