// Função de salvar – como guardar um tesouro cúbico!
global.salva_jogo = function() {
	    // Convertendo o inventário em um array (como empilhar blocos coloridos)
	    var _inv;
	    for (var _i = 0; _i < ds_grid_height(global.inventario_slots); _i++) {
	        for (var _j = 0; _j < ds_grid_width(global.inventario_slots); _j++) {
	            _inv[_j][_i] = global.inventario_slots[# _j, _i];
	        }
	    }
    
	    // Estrutura de dados – o coração do save, cheio de mistério e moedas!
	    var _dados = {
	        sdash: {
	            meux: obj_sdash.x,
	            meuy: obj_sdash.y,
	            rm: room,
	            vida: obj_sdash.vida,
	            mvida: obj_sdash.max_vida,
	            item_atual: global.item_player,
	            m_inimigos: global.inimigos_mortos,
	            moedas: global.moedas
	        },
	        inventario: _inv
	    };
    
	    // Converter pra JSON – transformando cubos em texto mágico
	    var _string = json_stringify(_dados);
    
	    // Abrindo o baú (arquivo) e guardando o tesouro
	    var _file = file_text_open_write("save.json");
	    file_text_write_string(_file, _string);
	    file_text_close(_file);
    
	    show_debug_message("Save completo! Sdash tá seguro em CúbicLand."); // Mensagem fofa pro debug
}


global.carrega_jogo = function() {
    // Checando se o save existe – nada de aventuras vazias!
    if (!file_exists("save.json")) {
        show_debug_message("Ops! Nenhum save encontrado. Vamos começar fresquinho, como um cubo recém-despetrificado!");
        return; // Sai sem drama
    }
    
    // Abrindo o baú misterioso
    var _file = file_text_open_read("save.json");
    var _string = file_text_read_string(_file);
    file_text_close(_file);
    
    // Parseando os dados – revelando segredos cúbicos!
    var _dados = json_parse(_string);
    
    // Armazenando temporariamente – como guardar moedas num chapéu
    var _temp_x = _dados.sdash.meux;
    var _temp_y = _dados.sdash.meuy;
    var _temp_room = _dados.sdash.rm;
    var _temp_vida = _dados.sdash.vida;
    var _temp_max_vida = _dados.sdash.mvida;
    var _temp_item = _dados.sdash.item_atual;
    var _temp_inimigos = _dados.sdash.m_inimigos;
    var _temp_moedas = _dados.sdash.moedas;
    
    // Restaurando inventário primeiro – blocos no lugar certo!
    for (var _i = 0; _i < ds_grid_height(global.inventario_slots); _i++) {
        for (var _j = 0; _j < ds_grid_width(global.inventario_slots); _j++) {
            global.inventario_slots[# _j, _i] = _dados.inventario[_j][_i];
        }
    }
    
    // Aplicando globals que não dependem do Sdash
    global.item_player = _temp_item;
    global.inimigos_mortos = _temp_inimigos;
    global.moedas = _temp_moedas;
    
    // Checando se o Sdash existe – se não, criamos ele como um herói surgindo do nada!
    var _sdash_inst = noone;
    if (instance_exists(obj_sdash)) {
        _sdash_inst = obj_sdash; // Usa o existente
    } else {
        // Cria na room atual (ou na inicial, se for menu)
        _sdash_inst = instance_create_layer(0, 0, "Instances", obj_sdash); // Posição temporária, ajusta depois
        show_debug_message("Sdash criado do éter cúbico! Pronto pra aventura.");
    }
    
    // Aplicando os valores no Sdash real
    _sdash_inst.vida = _temp_vida;
    _sdash_inst.max_vida = _temp_max_vida;
	_sdash_inst.active = true;
	global.pause = false
	_sdash_inst.image_xscale = 0.78125
	_sdash_inst.image_yscale = 0.78125
    
    // Transição pra room salva – com fade épico!
    if (room != _temp_room) {
        // Cria transição se você tiver obj_transition (sugestão abaixo)
        var _trans = instance_create_layer(0, 0, "Instances", obj_transition);
        _trans.target_room = _temp_room;
        _trans.target_x = _temp_x;
        _trans.target_y = _temp_y;
    } else {
        // Mesma room: só move o Sdash
        _sdash_inst.x = _temp_x;
        _sdash_inst.y = _temp_y;
    }
    
    show_debug_message("Load completo! Sdash tá de volta, com chapéu e tudo!");
}


//// Função de carregar – revivendo a aventura!
//global.carrega_jogo = function() {
//	    // Checando se o save existe (pra não petrificar o jogo)
//	    if (!file_exists("save.json")) {
//	         return; // Sai sem crashar
//	    }
    
//	    // Abrindo o baú
//	    var _file = file_text_open_read("save.json");
//	    var _string = file_text_read_string(_file);
//	    file_text_close(_file);
    
//	    // Parseando o JSON – despetrificando os dados
//	    var _dados = json_parse(_string);
    
//	    // Aplicando no Sdash – ele volta mais destemido que nunca!
//	    obj_sdash.x = _dados.sdash.meux;
//	    obj_sdash.y = _dados.sdash.meuy;
//	    room_goto(_dados.sdash.rm); // Use room_goto pra transitar suavemente
//	    obj_sdash.vida = _dados.sdash.vida;
//	    obj_sdash.max_vida = _dados.sdash.mvida;
//	    global.item_player = _dados.sdash.item_atual;
//	    global.inimigos_mortos = _dados.sdash.m_inimigos;
//	    global.moedas = _dados.sdash.moedas;
    
//	    // Restaurando o inventário – blocos de volta ao lugar!
//	    for (var _i = 0; _i < ds_grid_height(global.inventario_slots); _i++) {
//	        for (var _j = 0; _j < ds_grid_width(global.inventario_slots); _j++) {
//	            global.inventario_slots[# _j, _i] = _dados.inventario[_j][_i];
//	        }
//	    }
    
//	    show_debug_message("Load completo! Sdash tá de volta, pronto pra mais cubos e risadas!");
//}