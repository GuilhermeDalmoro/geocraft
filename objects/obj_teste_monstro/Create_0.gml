event_inherited();
nome_monstro = "teste";
vida = 120;
vida_max = 120;
check_descricao[0] = "teste, 10 de ataque e 99 de defesa";
acao[0] = "checar";
acao[1] = "provocar";
mostrar_vida = true;
pode_poupar = false;
ataque_id = "geometry_dash";
ataque_timer = 0;

x = display_get_width() / 2; // Centro da tela
y = 200;
image_xscale = 6;
image_yscale = 6;

// Inicia diálogo
var _dialogo = instance_create_layer(0, 0, "Instances", obj_dialogo);
_dialogo.npc_nome = "teste_inicio";
_dialogo.ativo = true;