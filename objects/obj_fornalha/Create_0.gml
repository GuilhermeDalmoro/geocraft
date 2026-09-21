depth = -y;

image_xscale = 1.5;
image_yscale = 1.5;
image_speed = 1;
solid = true;

receitas_fornalha = [
    {
        nome : "Pedra refinada",
        ingredientes : [
            { id : ITENS.pedra, qtd : 4 }
        ],
        resultado : ITENS.bloco_pedra,
        quantidade : 1,
        duracao : 240
    },
    {
        nome : "Pocao de fogo",
        ingredientes : [
            { id : ITENS.reia, qtd : 2 },
            { id : ITENS.flor, qtd : 3 }
        ],
        resultado : ITENS.cura,
        quantidade : 1,
        duracao : 300
    },
    {
        nome : "Espada de fogo",
        ingredientes : [
            { id : ITENS.bloco_pedra, qtd : 5 },
            { id : ITENS.reia, qtd : 1 }
        ],
        resultado : ITENS.espadalv1,
        quantidade : 1,
        duracao : 420
    }
];

fornalha_state = gc_world_furnace_get(room_get_name(room), x, y, true);

sprite_index = fornalha_state.active ? spr_fornalha : spr_fornalha_fechada;
