depth = -y;

image_xscale = 1.5;
image_yscale = 1.5;
image_speed = 1;
solid = true;

// UI local: a propria fornalha controla a interface.
// Isso evita referencia quebrada entre obj_fornalha e um objeto de UI temporario.
ui_open = false;
ui_selected = 0;
ui_open_lock = 0;
ui_message = "";
ui_message_timer = 0;

receitas_fornalha = [
    {
        nome : "Pedra refinada",
        descricao : "Comprime pedra bruta em um bloco resistente.",
        ingredientes : [
            { id : ITENS.pedra, qtd : 4 }
        ],
        resultado : ITENS.bloco_pedra,
        quantidade : 1,
        combustivel : 1,
        duracao : 240
    },
    {
        nome : "Pocao de geleia",
        descricao : "Aquece dejeto e flores. Nao pergunte pela receita.",
        ingredientes : [
            { id : ITENS.reia, qtd : 2 },
            { id : ITENS.flor, qtd : 3 }
        ],
        resultado : ITENS.pocaogeleia,
        quantidade : 1,
        combustivel : 1,
        duracao : 300
    },
    {
        nome : "Espada cubica reforcada",
        descricao : "Reforca uma lamina com material refinado e dejeto.",
        ingredientes : [
            { id : ITENS.bloco_pedra, qtd : 5 },
            { id : ITENS.reia, qtd : 1 }
        ],
        resultado : ITENS.espadalv1,
        quantidade : 1,
        combustivel : 1,
        duracao : 420
    }
];

fornalha_state = gc_world_furnace_get(room_get_name(room), x, y, true);

// Compatibilidade com estados vindos de saves mais antigos.
if (!variable_struct_exists(fornalha_state, "active")) fornalha_state.active = false;
if (!variable_struct_exists(fornalha_state, "recipe_id")) fornalha_state.recipe_id = -1;
if (!variable_struct_exists(fornalha_state, "progress")) fornalha_state.progress = 0;
if (!variable_struct_exists(fornalha_state, "duration")) fornalha_state.duration = 0;
if (!variable_struct_exists(fornalha_state, "output_id")) fornalha_state.output_id = -1;
if (!variable_struct_exists(fornalha_state, "output_qty")) fornalha_state.output_qty = 0;
if (!variable_struct_exists(fornalha_state, "total_batches")) fornalha_state.total_batches = 0;

sprite_index = fornalha_state.active ? spr_fornalha : spr_fornalha_fechada;
