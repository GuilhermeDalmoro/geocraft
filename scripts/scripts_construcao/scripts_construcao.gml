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
    // Pegando mais informações do material dele
    var _itens = mat.item;
    var _qtds = mat.qtd;
    var _x1 = _x - 300;
    var _y1 = _y;
    var _x2 = _x;
    var _y2 = _y + 200;
    var _mouse_click = mouse_check_button_pressed(mb_left);
    draw_set_color(c_navy);
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    draw_set_color(c_white);
    
    // Iterando pela minha lista de materiais
    var _qtd = array_length(_itens);
    for (var _i = 0; _i < _qtd; _i++) {
        
        var _atual = _itens[_i];
        var _qtd_pos_inv = procura_item_inventario(_atual);
        var _item_struct = global.itens[| _atual];
        var _marg_x = 30;
        var _marg_y = 30;
        
        if (_item_struct != undefined) {
            
            var _material_nome = _item_struct.nome;
            var _material_spr = _item_struct.spr;
            var _material_img = _item_struct.frames;
            var _material_qtd = _qtds[_i];
            
            draw_set_color(c_white);
            
            var _cor = (_qtd_pos_inv < _material_qtd) ? c_gray : c_white;
            
            // Desenhando o texto (com qtd pra ficar completo)
            draw_set_color(c_black);
            draw_text(_x1 + _marg_x, _y1 + _i * 30 + _marg_y / 2, _material_nome + " x" + string(_material_qtd));
            draw_set_color(-1)
            draw_set_color(_cor); // Usa _cor pra "Possui"
            draw_text(_x1 + _marg_x + 130, _y1 + _i * 30 + _marg_y / 2, "Possui: x" + string(_qtd_pos_inv));
            draw_set_color(-1); // Reset após cada texto, evitando vazamento de cor
            // Desenhando a sprite
            draw_sprite(_material_spr, _material_img, _x1 + _marg_x / 2, _y1 + _i * 30 + _marg_y);
        }
    }
};
}