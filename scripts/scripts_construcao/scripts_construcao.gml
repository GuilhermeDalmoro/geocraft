// Estrutura com a lista de materiais pra construção
function cria_materiais(_item, _qtd) constructor {
    item = _item;
    qtd = _qtd;
}

// Estrutura de construção
function cria_estrutura(_nome, _desc, _materiais) constructor {

    nome = _nome;
    desc = _desc;
    mat = _materiais;

    // Método pra desenhar as informações da estrutura
    desenha_info = function(_x, _y) {

        // Pegando materiais
        var _itens = mat.item;
        var _qtds = mat.qtd;

        // área da caixa
        var _x1 = _x - 300;
        var _y1 = _y;
        var _x2 = _x;
        var _y2 = _y + 200;

        // cores da UI
        var _cor_fundo = make_color_rgb(25,35,60);
        var _cor_borda = make_color_rgb(120,180,255);

        var _borda = 4;

        // desenha borda
        draw_set_color(_cor_borda);
        draw_rectangle(_x1 - _borda, _y1 - _borda, _x2 + _borda, _y2 + _borda, false);

        // desenha fundo
        draw_set_color(_cor_fundo);
        draw_rectangle(_x1, _y1, _x2, _y2, false);

        draw_set_color(c_white);

        // quantidade de materiais
        var _qtd = array_length(_itens);

        for (var _i = 0; _i < _qtd; _i++) {

            var _atual = _itens[_i];
            var _qtd_pos_inv = procura_item_inventario(_atual);
            var _item_struct = global.itens[| _atual];

            // posições
            var _spr_x = _x1 + 15;
            var _text_x = _x1 + 38;
            var _linha_y = _y1 + _i * 30 + 30;

            if (_item_struct != undefined) {

                var _material_nome = _item_struct.nome;
                var _material_spr = _item_struct.spr;
                var _material_img = _item_struct.frames;
                var _material_qtd = _qtds[_i];

                // cor dependendo se tem material
                var _cor = (_qtd_pos_inv < _material_qtd)
                    ? make_color_rgb(200,200,200)
                    : make_color_rgb(180,255,180);

                // texto principal
                var _texto_material = _material_nome + " x" + string(_material_qtd);

                draw_set_color(make_color_rgb(230,230,255));
                draw_text(_text_x, _linha_y - 10, _texto_material);

                // largura do texto
                var _largura = string_width(_texto_material);

                // espaço entre colunas
                var _espaco = 26;

                // desenha "possui"
                draw_set_color(_cor);
                draw_text(_text_x + _largura + _espaco, _linha_y - 10, "tem: x" + string(_qtd_pos_inv));

                draw_set_color(c_white);

                // desenha sprite
                draw_sprite(_material_spr, _material_img, _spr_x, _linha_y);
            }
        }
    };
}

/// Remove uma quantidade de um item do inventario.
/// Retorna true apenas se conseguiu remover tudo.
function remove_do_inventario(_item_id, _qtd) {
    if (_qtd <= 0) return true;
    if (!variable_global_exists("inventario_slots")) return false;
    if (!ds_exists(global.inventario_slots, ds_type_grid)) return false;

    if (procura_item_inventario(_item_id) < _qtd) {
        return false;
    }

    var _faltando = _qtd;
    var _w = ds_grid_width(global.inventario_slots);
    var _h = ds_grid_height(global.inventario_slots);

    for (var _y = 0; _y < _h && _faltando > 0; _y++) {
        for (var _x = 0; _x < _w && _faltando > 0; _x++) {
            var _slot = global.inventario_slots[# _x, _y];

            if (!is_struct(_slot)) continue;
            if (_slot.id != _item_id) continue;

            var _take = min(_faltando, _slot.quantity);

            _slot.quantity -= _take;
            _faltando -= _take;

            if (_slot.quantity <= 0) {
                global.inventario_slots[# _x, _y] = noone;
            }
        }
    }

    return (_faltando <= 0);
}
