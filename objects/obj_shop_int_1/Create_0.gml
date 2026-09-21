itens_venda = [
    { id : ITENS.cura, nome : "Cura", preco : 18 },
    { id : ITENS.pocaogeleia, nome : "Pocao de geleia", preco : 32 },
    { id : ITENS.tomate, nome : "Tomate", preco : 8 },
    { id : ITENS.madeira, nome : "Madeira", preco : 6 },
    { id : ITENS.pedra, nome : "Pedra", preco : 6 }
];

index = 0;
fechando = false;

global.pause = true;

if (variable_global_exists("game_state") && is_struct(global.game_state)) {
    global.game_state.runtime.pause = true;
    global.game_state.runtime.modal_ui = "loja";
}

gc_quest_toast("Loja aberta", 45);
