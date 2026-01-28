aberto = true;                     // já abre ao criar (ou mude para false e abra manualmente)
escala = 3;                        // aumentei um pouco pra 15×15 ficar mais visível (60×60 efetivo)

loot_w = sprite_get_width(spr_hud_loot) * escala;
loot_h = sprite_get_height(spr_hud_loot) * escala;

opcoes = [];

// Escolhe 3 insígnias únicas
var temp_pool = [];
array_copy(temp_pool, 0, global.insignias, 0, array_length(global.insignias));

for (var i = 0; i < 3 && array_length(temp_pool) > 0; i++) {
    var idx = irandom(array_length(temp_pool) - 1);
    array_push(opcoes, temp_pool[idx]);
    array_delete(temp_pool, idx, 1);
}

estrelas_total     = irandom_range(2, 5);
estrelas_reveladas = 0;
timer_revelacao    = 0;
escolha_feita      = false;
escolha_index      = -1;

fonte              = fnt_dialogo_small;   // 13 px – vamos usar ela em tudo que for texto pequeno