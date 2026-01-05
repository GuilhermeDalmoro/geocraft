if (global.comeca_batalha) {
    if (largura_atual < global.borda_largura_arena) {
        largura_atual += ((global.borda_largura_arena - largura_atual) / 2);
    }
    if (largura_atual > global.borda_largura_arena) {
        largura_atual -= ((largura_atual - global.borda_largura_arena) / 2);
    }
    if (altura_atual < global.borda_altura_arena) {
        altura_atual += ((global.borda_altura_arena - altura_atual) / 2);
    }
    if (altura_atual > global.borda_altura_arena) {
        altura_atual -= ((altura_atual - global.borda_altura_arena) / 2);
    }
    if (keyboard_check_pressed(vk_space) && global.turno == 1) {
        global.borda_largura_arena = random(680);
        global.borda_altura_arena = random(250);
    }
}