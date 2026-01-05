if (keyboard_check_pressed(vk_space)) {
    repeat(num_slots) { 
        selected = (selected + 1) mod num_slots;
        if (global.tem_magia[selected]) break;	
    }

    // resetar escalas
    for (var i = 0; i < num_slots; i++) {
        escala_alvo[i] = 1;
    }
    escala_alvo[selected] = 2;
    global.magia_selecionada = selected;	
}

// Deselecionar com shift
if (keyboard_check_pressed(vk_shift)) {
    global.magia_selecionada = noone;
    // resetar todas as escalas para 1
    for (var i = 0; i < num_slots; i++) {
        escala_alvo[i] = 1;
    }
}

// Suavizar escala
for (var i = 0; i < num_slots; i++) {
    escala[i] = lerp(escala[i], escala_alvo[i], 0.2);
}
