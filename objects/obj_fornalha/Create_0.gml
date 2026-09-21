// Inventário interno da fornalha (ela tem seus próprios slots)
fornalha_slots = ds_grid_create(5, 2);           // 5x2 = 10 slots
ds_grid_clear(fornalha_slots, noone);

aberto = false;

// Receitas específicas da fornalha
receitas_fornalha = [
    { nome: "Lingote de Pedra", ingredientes: [[ITENS.pedra, 8]], resultado: ITENS.bloco_pedra, quantidade: 4 },
    { nome: "Poção de Fogo", ingredientes: [[ITENS.reia, 2], [ITENS.flor, 3]], resultado: ITENS.cura, quantidade: 1 },
    { nome: "Espada de Fogo", ingredientes: [[ITENS.bloco_pedra, 5], [ITENS.reia, 1]], resultado: ITENS.espadalv1, quantidade: 1 }
];


depth = -y;

image_xscale = 1.5;
image_yscale = 1.5;

image_speed = 1;
sprite_index = spr_fornalha

solid = true;