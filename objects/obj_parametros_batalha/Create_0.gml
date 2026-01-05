global.borda_largura_arena = 640;
global.borda_altura_arena = 200;
global.vida_arena_sdash = 20;
global.velocidade_arena_sdash = 4;
global.invframes = 0;
global.ui_selecao_menu = 0;
global.batalha_menu = -1;
global.turno = 0;
global.comeca_batalha = true;
global.item_batalha[0] = "Chapeu";
global.item_batalha[1] = "Elixir";
global.item_batalha[2] = "Graveto";
global.item_batalha[3] = "Pistola";
global.pode_fugir = true;

// Inicializa array global.inimigo
global.inimigo = array_create(1, noone);
global.inimigo[0] = instance_create_depth(display_get_width() / 2, 200, 1, obj_teste_monstro);
global.inimigo[0].image_xscale = 6;
global.inimigo[0].image_yscale = 6;

instance_create_depth(640, 720 - (global.borda_altura_arena / 2) - 40, 1, obj_arena_batalha);
instance_create_depth(0, 0, 0, obj_botao_controller);
