qtd = 1;

meu_id = 0;  // Será setado baseado em image_index

image_speed = 0;

image_xscale = .5
image_yscale = image_xscale

xscale = image_xscale;
yscale = image_yscale;

z = -10;
velz = 0;
grav = .25;
direction = random(364);
speed = 3;

osc_freq = random_range(0.002, 0.005);
osc_amp  = random_range(.4, .6);
osc_offset = random(1000);

destruir = false;
posso_destruir = false;
juntou = false; // Nova variável para evitar múltiplas junções
alarm[0] = 60

me_destruir = function(){
    image_alpha = lerp(image_alpha, 0, 0.1);
    
    if (image_alpha <= 0.1){
        instance_destroy();
    }
}

junta_item = function(){
    if (destruir || juntou) exit; // Sai se já está destruindo ou já juntou
    
    // Pegando o drop mais próximo que não está sendo destruído
    var _prox = collision_rectangle(bbox_left - 10, bbox_top - 10, bbox_right + 10, bbox_bottom + 10, obj_drop, 0, 1);
    
    if (_prox && !_prox.destruir && !_prox.juntou && _prox.meu_id == meu_id && _prox.posso_destruir) {
        var _item = global.itens[| meu_id];
        var _espaco = _item.max_stack - qtd;
        if (_espaco > 0) {
            if (_prox.qtd <= _espaco) {
                qtd += _prox.qtd;
                _prox.destruir = true;
                _prox.juntou = true; // Marca como juntado
                juntou = true; // Marca este drop como juntado
            } else {
                qtd = _item.max_stack;
                _prox.qtd -= _espaco;
                _prox.juntou = true; // Marca o outro como juntado
                juntou = true; // Marca este drop como juntado
            }
        }
    }
}



//// Setando meu_id baseado em image_index (pedra = 9, madeira=10, etc.)
meu_id = 9 + image_index;  // ITENS.pedra = 9

//// Pegando as minhas informações
var _info = global.itens[| meu_id];
nome = _info.nome;
sprite = _info.spr;
