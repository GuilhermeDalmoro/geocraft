// Nao troca magia enquanto dialogo, inventario ou outro menu esta pausando o jogo.
if (!global.pause && keyboard_check_pressed(vk_space)) {
    var _found = false;

    repeat (num_slots) {
        selected = (selected + 1) mod num_slots;

        if (is_array(global.tem_magia) && global.tem_magia[selected]) {
            _found = true;
            break;
        }
    }

    if (_found) {
        for (var _i = 0; _i < num_slots; _i++) {
            escala_alvo[_i] = 1;
        }

        escala_alvo[selected] = 2;
        global.magia_selecionada = selected;

        gc_quest_toast("Magia: " + gc_magic_name(selected), 55);
    }
}

if (!global.pause && keyboard_check_pressed(vk_shift)) {
    global.magia_selecionada = noone;

    for (var _i = 0; _i < num_slots; _i++) {
        escala_alvo[_i] = 1;
    }
}

for (var _i = 0; _i < num_slots; _i++) {
    escala[_i] = lerp(escala[_i], escala_alvo[_i], 0.2);
}
