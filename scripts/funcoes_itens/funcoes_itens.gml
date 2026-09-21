#region Cria os itens
///@function cria_item
///
function cria_item(_meu_id, _nome, _desc, _spr, _frame, _dano, _cura, _atributo, _rar, _vel, _tipo, _max_stack = 1) constructor {
    id = _meu_id;
    
    nome = _nome;
    desc = _desc;
    spr = _spr;
    frames = _frame;
    dano = _dano;
    cura = _cura;
    atributo = _atributo;
    rar = _rar;
    vel = _vel;
    tipo = _tipo;
    max_stack = _max_stack;
    
    usa_item = function() {
            if (tipo == TIPO_ITENS.armamento) {
                global.item_player = self; // Apenas armamentos equipam
            }
    }
    
    usa_arma = function() {
        // Função padrão pra armamentos, sobrescrita por arma
    }
    
}
function procura_item_inventario(_id_item) {
    var _qtd_atual = 0;
    var _colunas = ds_grid_width(global.inventario_slots);
    var _linhas = ds_grid_height(global.inventario_slots);
    for (var _i = 0; _i < _linhas; _i++) {
        for (var _j = 0; _j < _colunas; _j++) {
            var _slot = global.inventario_slots[# _j, _i];
            if (is_struct(_slot) && _slot.id == _id_item) {
                _qtd_atual += _slot.quantity;
            }
        }
    }
    return _qtd_atual; // Retorna a quantidade total do item no inventário (0 se não tem)
}
enum ITENS {
    reia,
    arco,
    gd,
    cura,
    espadalv1,
    boladeneve,
    orb,
    moedaenferrujada,
    pocaogeleia,
    pedra,
    madeira,
    cerca,
    flor,
    bloco_pedra,
    bloco_madeira,
    terra,
    tomate,
    trigo,
    vara_pesca,
    cogumelo
}
enum TIPO_ITENS{
    consumivel,
    material,
    armamento
}
    
enum LISTA_CONSTRUCAO{
    fechado,
    forge,
    agro,
    total
}
enum LISTA_FORGE{
    fornalha,
    mesa,
    bigorna,
    extrator
    
}

global.menu_construcao = LISTA_CONSTRUCAO.fechado;

var _materiais_fornalha = new cria_materiais([ITENS.pedra, ITENS.madeira], [10, 5])
var _fornalha = new cria_estrutura("Fornalha", "Cria outras construcoes", _materiais_fornalha)

var _materiais_mesa = new cria_materiais([ITENS.madeira], [5])
var _mesa = new cria_estrutura("Mesa", "Uma mesa de trabalho", _materiais_mesa)

var _materiais_bigorna = new cria_materiais([ITENS.bloco_pedra, ITENS.madeira], [3, 4])
var _bigorna = new cria_estrutura("Bigorna", "Serve pra martelar espadas", _materiais_bigorna)

var _materiais_extrator = new cria_materiais([ITENS.bloco_pedra], [3])
var _extrator = new cria_estrutura("Extrator", "Serve pra cavar", _materiais_extrator)

var _forge = [_fornalha, _mesa, _bigorna, _extrator]

var _agro = ["Fertilizantes", "Conservação", "Textil"]

global.itens_construcao = [[], _forge, _agro]

//criando a minha lista de itens
global.itens = ds_list_create();
global.item_player = noone;

#endregion

#region Itens
//criando um item
var _reia = new cria_item(ITENS.reia, "dejeto", "Um pequeno pedaço de dejeto alienigena fresquinho", spr_item_reia, 0, 0, 1, "Deixa vc mais feliz", "Comum", 0, TIPO_ITENS.consumivel);
                                    
var _arco = new cria_item(ITENS.arco, "Arco", "Um arco que destroi tudo pela frente", spr_arco, 0, 10, 1, "Deixa voce mais sanguinario", "Padrao", 10, TIPO_ITENS.armamento);
                                    
var _gd = new cria_item(ITENS.gd, "gd", "Um cubinho que é sapeca", spr_item_gd, 0, 12, 10, "Deixa voce mais sanguinario", "Padrao", 10, TIPO_ITENS.consumivel);
                                    
var _cura = new cria_item(ITENS.cura, "cura", "Uma poção de cura: +10hp", spr_pocao_cura, 0, 12, 10, "Deixa voce mais sanguinario", "Padrao", 10, TIPO_ITENS.consumivel);
                            
var _espadalv1 = new cria_item(ITENS.espadalv1, "espada", "Uma espada de agua, em que machuca muito :(", spr_espada, 0, 1, 1, 1, 1, 1, TIPO_ITENS.armamento);
                            
var _neve = new cria_item(ITENS.boladeneve, "Neve", "Isto é uma bolinha de neve, leve ao fim do planeta", spr_particula, 0, 1, 1, 1, 1, 1, TIPO_ITENS.material, 64);
                                                                                    
var _orb = new cria_item(ITENS.orb, "orb", "Recupera 3 de Hp", spr_orb, 0, 1, 1, 1, 1, 1, TIPO_ITENS.consumivel);
                                                
var _moeda_enferrujada = new cria_item(ITENS.moedaenferrujada, "Moeda enferrujada", "Tem valor sentimental... pra alguem", spr_moeda_enferrujada, 0, 1, 1, 1, 1, 1, TIPO_ITENS.consumivel);
                                                                                    
var _pocao_geleia = new cria_item(ITENS.pocaogeleia, "poção geleia", "Uma geleia gostosinha", spr_pocao_geleia, 0, 12, 10, "Deixa voce mais sanguinario", "Padrao", 10, TIPO_ITENS.consumivel);
                                                                                            
var _pedra = new cria_item(ITENS.pedra, "Pedra", "Pedregulho de pedra", spr_drop, 0, 1, 0, "nenhum", "Comum", 0, TIPO_ITENS.material, 64);
                                                                                            
var _madeira = new cria_item(ITENS.madeira, "Madeira", "Um pedaço de madeira", spr_drop, 1, 1, 0, "nenhum", "Comum", 0, TIPO_ITENS.material, 64);
                                                                                            
var _cerca = new cria_item(ITENS.cerca, "Cerca", "Estacas de madeira para cercar lugares", spr_drop, 2, 1, 0, "nenhum", "Padrao", 0, TIPO_ITENS.material, 64);
                                                                                            
var _flor = new cria_item(ITENS.flor, "Flor", "Uma simples flor", spr_drop, 3, 1, 0, "nenhum", "Comum", 0, TIPO_ITENS.material, 64);
                                                                                            
var _bloco_pedra = new cria_item(ITENS.bloco_pedra, "Bloco de pedra", "Uma caralhada de pedra", spr_drop, 4, 1, 0, "nenhum", "Comum", 0, TIPO_ITENS.material, 64);
                                                                                            
var _bloco_madeira = new cria_item(ITENS.bloco_madeira, "Bloco de madeira", "Uma caralhada de madeira", spr_drop, 5, 1, 0, "nenhum", "Comum", 0, TIPO_ITENS.material, 64);
                                                                                            
var _terra = new cria_item(ITENS.terra, "Terra", "Um pouco de terra", spr_drop, 6, 1, 0, "nenhum", "Comum", 0, TIPO_ITENS.material, 64);
                                                                                            
var _tomate = new cria_item(ITENS.tomate, "Tomate", "Um tomatinho", spr_tomate, 0, 0, 2, "nenhum", "Comum", 0, TIPO_ITENS.consumivel, 6);

var _trigo = new cria_item(ITENS.trigo, "Trigo", "farinha de trigo", spr_farinacios, 1, 0, 1, 1, 1, 2, TIPO_ITENS.consumivel, 6)

var _vara_pesca = new cria_item(ITENS.vara_pesca, "Vara de pesca", "Uma vara de pesca", spr_vara_pesca, 0, 0, 1, "Serve para pescar", "Padrao", 1, TIPO_ITENS.armamento);

var _cogumelo = new cria_item(ITENS.cogumelo, "Cogumelo", "Um cogumelo q te deixa doidão", spr_cogumelo, 0, 0, 1, "deixa vc diferente", "Padrao", 1, TIPO_ITENS.consumivel);

#endregion

#region Funcionalidades dos itens consumiveis

_reia.usa_item = function() {
    with (obj_sdash) {
        vida-=1;
        instance_create_depth(x, y, depth - 10, obj_brilho);
    }
};
_gd.usa_item = function(){
    with(obj_sdash){
        dano = 8
        cria_brilho(x, y, c_yellow)
    }
}
_cura.usa_item = function(){
    with(obj_sdash) {
        vida = min(vida + 4, max_vida);
        cria_brilho(x, y, c_purple)
    }
}
_orb.usa_item = function(){
    with(obj_sdash) {
        vida = min(vida +1 , max_vida)
    }
}
_pocao_geleia.usa_item = function(){
    with(obj_sdash) {
        vida = min(vida + 10, max_vida);
        cria_brilho(x, y, c_red)
    }
}
_tomate.usa_item = function(){
    with(obj_sdash){
        vida = min(vida + 2, max_vida);
    }
}
_cogumelo.usa_item = function(){
    with(obj_sdash){
        //instance_create_layer(x, y, )
    }
}

#endregion

#region Ataques das armas

_espadalv1.usa_arma = function() {
    if (!instance_exists(obj_sdash)) return;

    with (obj_sdash) {
        if (global.pause) exit;

        // Usa o combate real do Sdash. A sequence antiga continuava bonita,
        // mas nao possuia o momento de dano ligado na timeline.
        scr_sdash_iniciar_corpo_a_corpo(3);
    }
}

_arco.usa_arma = function() {
    if (!instance_exists(obj_sdash)) return;

    with (obj_sdash) {
        if (global.pause) exit;

        arco_dano = 3;
        image_index = 0;
        image_speed = 1;
        estado = scr_sdash_arco;
    }
}

_vara_pesca.usa_arma = function() {
    if (instance_exists(obj_sdash)) {
        gc_quest_toast("A vara de pesca ainda nao aprendeu a pescar. Cubos...", 90);
    }
}

#endregion

#region Salvando os meus itens na minha lista de itens

ds_list_add(global.itens, _reia, _arco, _gd, _cura, _espadalv1, _neve, _orb, _moeda_enferrujada, _pocao_geleia, _pedra, _madeira, _cerca, _flor, _bloco_pedra, _bloco_madeira, _terra, _tomate, _trigo, _vara_pesca, _cogumelo);
///@function adiciona_ao_inventario
///
function adiciona_ao_inventario(_item_id, _qtd) {
    if (_qtd <= 0) return true;
    if (!ds_exists(global.inventario_slots, ds_type_grid)) return false;
    if (!ds_exists(global.itens, ds_type_list)) return false;
    if (_item_id < 0 || _item_id >= ds_list_size(global.itens)) return false;

    var _item = global.itens[| _item_id];
    if (!is_struct(_item)) return false;

    var _colunas = ds_grid_width(global.inventario_slots);
    var _linhas = ds_grid_height(global.inventario_slots);
    var _max_stack = max(1, _item.max_stack);
    var _original_qtd = _qtd;

    // Primeiro calcula capacidade. Assim a funcao nunca altera metade do
    // inventario e depois retorna false.
    var _capacidade = 0;

    for (var _y = 0; _y < _linhas; _y++) {
        for (var _x = 0; _x < _colunas; _x++) {
            var _slot = global.inventario_slots[# _x, _y];

            if (is_struct(_slot)) {
                if (_slot.id == _item_id && _slot.quantity < _max_stack) {
                    _capacidade += _max_stack - _slot.quantity;
                }
            }
            else if (!is_struct(_slot)) {
                _capacidade += _max_stack;
            }
        }
    }

    if (_capacidade < _qtd) return false;

    // Completa stacks existentes.
    if (_max_stack > 1) {
        for (var _y = 0; _y < _linhas && _qtd > 0; _y++) {
            for (var _x = 0; _x < _colunas && _qtd > 0; _x++) {
                var _slot = global.inventario_slots[# _x, _y];

                if (is_struct(_slot)
                && _slot.id == _item_id
                && _slot.quantity < _max_stack) {

                    var _move = min(_qtd, _max_stack - _slot.quantity);
                    _slot.quantity += _move;
                    _qtd -= _move;
                }
            }
        }
    }

    // Distribui o restante em slots vazios respeitando max_stack.
    for (var _y = 0; _y < _linhas && _qtd > 0; _y++) {
        for (var _x = 0; _x < _colunas && _qtd > 0; _x++) {
            var _slot = global.inventario_slots[# _x, _y];

            if (!is_struct(_slot)) {
                var _move = min(_qtd, _max_stack);
                global.inventario_slots[# _x, _y] = {
                    id : _item_id,
                    quantity : _move
                };
                _qtd -= _move;
            }
        }
    }

    // Eventos de coleta alimentam missoes futuras (livros, pergaminhos etc.).
    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        gc_quest_notify("coletar", string(_item_id), _original_qtd);

        if (variable_struct_exists(_item, "nome")) {
            gc_quest_notify("coletar", string(_item.nome), _original_qtd);
        }
    }

    return true;
}


function remove_do_inventario(_item_id, _qtd) {
    if (_qtd <= 0) return true;
    if (!variable_global_exists("inventario_slots")) return false;
    if (!ds_exists(global.inventario_slots, ds_type_grid)) return false;

    var _total = procura_item_inventario(_item_id);
    if (_total < _qtd) return false;

    var _faltando = _qtd;
    var _w = ds_grid_width(global.inventario_slots);
    var _h = ds_grid_height(global.inventario_slots);

    for (var _y = 0; _y < _h && _faltando > 0; _y++) {
        for (var _x = 0; _x < _w && _faltando > 0; _x++) {
            var _slot = global.inventario_slots[# _x, _y];

            if (!is_struct(_slot) || _slot.id != _item_id) continue;

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

// Função pra checar se tem materiais suficientes (escalável pra qualquer receita)
function tem_materiais(_estrutura) {
    var _itens = _estrutura.mat.item;
    var _qtds = _estrutura.mat.qtd;
    var _qtd = array_length(_itens);
    for (var _i = 0; _i < _qtd; _i++) {
        var _atual = _itens[_i];
        var _qtd_req = _qtds[_i];
        var _qtd_atual = procura_item_inventario(_atual);
        if (_qtd_atual < _qtd_req) return false; // Não tem suficiente, tipo Sdash sem tomate pra uma poção épica
    }
    return true; // Tem tudo, pronto pra craftar!
}

// Função pra consumir materiais (remove do inventário, stack a stack)
function consome_materiais(_estrutura) {
    var _itens = _estrutura.mat.item;
    var _qtds = _estrutura.mat.qtd;
    var _qtd = array_length(_itens);
    for (var _i = 0; _i < _qtd; _i++) {
        var _atual = _itens[_i];
        var _qtd_req = _qtds[_i];
        var _linhas = ds_grid_height(global.inventario_slots);
        var _colunas = ds_grid_width(global.inventario_slots);
        for (var _yy = 0; _yy < _linhas; _yy++) {
            for (var _xx = 0; _xx < _colunas; _xx++) {
                var _slot = global.inventario_slots[# _xx, _yy];
                if (is_struct(_slot) && _slot.id == _atual) {
                    if (_slot.quantity > _qtd_req) {
                        _slot.quantity -= _qtd_req;
                        _qtd_req = 0;
                    } else {
                        _qtd_req -= _slot.quantity;
                        global.inventario_slots[# _xx, _yy] = noone; // Remove slot vazio
                    }
                    if (_qtd_req <= 0) break;
                }
            }
            if (_qtd_req <= 0) break;
        }
    }
}

#endregion