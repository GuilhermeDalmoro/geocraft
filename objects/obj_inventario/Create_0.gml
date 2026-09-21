if (instance_number(obj_inventario) > 1) {
    instance_destroy();
    exit;
}

#region variaveis
//criando a dsgrid do inventario
global.inventario_slots = ds_grid_create(8,4); //largura, altura da grid
//limpando a ds grid pra nao acumular lixo na memoria
ds_grid_clear(global.inventario_slots, 0); // 0 = vazio
//me dando um item (agora com structs {id, quantity})
#region Preenchendo slots
global.inventario_slots[# 0, 0] = { id: ITENS.reia, quantity: 1 };
global.inventario_slots[# 1, 0] = { id: ITENS.espadalv1, quantity: 1 };
global.inventario_slots[# 2, 0] = { id: ITENS.madeira, quantity: 4 };
global.inventario_slots[# 3, 0] = { id: ITENS.pedra, quantity: 4 };
//global.inventario_slots[# 5, 0] = { id: ITENS.gd, quantity: 1 };
//global.inventario_slots[# 6, 0] = { id: ITENS.pocaogeleia, quantity: 8 };
//global.inventario_slots[# 7, 0] = { id: ITENS.moedaenferrujada, quantity: 1 };
//global.inventario_slots[# 0, 1] = { id: ITENS.orb, quantity: 1 };
#endregion
//variavel que indica se o inventario vai ou nao estar aberto
inventario = false;
//variavel que sera a escala da imagem
escala = 3;
//começo dos slots do inventario
comeco_x = 15 * escala;
comeco_y = 20 * escala;
//quantos slots existem na horizontal e vertical do inventario
slot_h = 8;
slot_v = 4;
//total de slots no inventario
total = slot_h * slot_v;
//tamanho do slot
tamanho_slot = 16 * escala;
//buffer é a divisoria entre slots que nao faz nada so separa mesmo
buffer = 1 * escala;
//pegando as medidas da sprite do inventario
inventario_a = sprite_get_width(spr_inventario) * escala;
inventario_l = sprite_get_height(spr_inventario) * escala;
global.item_mouse = noone; // Agora é {id, quantity} ou noone
#endregion
#region funcoes
//para encontrar o item no inventario
encontra_item = function(_x, _y) {
    return global.inventario_slots[# _x, _y];
}
troca_item = function(_x, _y, _item_struct) {
    var _item_guardado = global.inventario_slots[# _x, _y];
    if (_item_struct && _item_guardado && _item_struct.id == _item_guardado.id) {
        var _item = global.itens[| _item_struct.id];
        if (_item.max_stack > 1) {
            var _espaco = _item.max_stack - _item_guardado.quantity;
            if (_item_struct.quantity <= _espaco) {
                _item_guardado.quantity += _item_struct.quantity;
                return noone; // Juntou tudo
            } else {
                _item_guardado.quantity = _item.max_stack;
                _item_struct.quantity -= _espaco;
                return _item_struct; // Retorna excesso
            }
        }
    }
    global.inventario_slots[# _x, _y] = _item_struct;
    return _item_guardado;
}
split_item = function(_x, _y) {
    var _slot = global.inventario_slots[# _x, _y];
    if (_slot && _slot.quantity > 1) {
        var _item = global.itens[| _slot.id];
        if (_item.max_stack > 1) {
            var _metade = floor(_slot.quantity / 2);
            _slot.quantity -= _metade;
            return { id: _slot.id, quantity: _metade };
        }
    }
    return noone;
}
desenha_inventario = function(){
            //se ele n tiver ativo ent n desenha
        //if !obj_sdash.active exit
        // Inicializando o inventário
        // Pegando a largura e altura da GUI
        var _guil = display_get_gui_width();
        var _guia = display_get_gui_height();
        // Coordenadas do mouse na GUI
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        // Desenhando o inventário
        if inventario == true {
            var _invx = _guil / 2 - inventario_l / 2;
            var _invy = _guia / 2 - inventario_a / 2;
            // Desenhar o sprite do inventário na posição calculada
            draw_sprite_ext(spr_inventario, 0, _invx, _invy, escala, escala, 0, c_white, 1);
    
if (global.item_player != noone && is_struct(global.item_player)) {
        draw_sprite_ext(global.item_player.spr, global.item_player.frames, 1016, 582, 2, 2, 0, c_white, 1);
        // Checar clique na área do item equipado (ajustado pra 64x64 com escala 2, pra caber sprites maiores)
        //draw_rectangle(1000, 564, 1000 + 32, 564 + 32, true)
        if point_in_rectangle(_mx, _my, 1000, 564, 1000 + 32, 564 + 32) {
             draw_sprite_ext(spr_inventario_seletor, 0, 1000, 564, 2, 2, 0, c_white, 1);
              if mouse_check_button_released(mb_right) && !global.item_mouse {
                // Tenta adicionar o item equipado de volta ao inventário (com checagem de stack)
                   if (adiciona_ao_inventario(global.item_player.id, 1)) {
                        global.item_player = noone; // Desequipa, Sdash fica livre pra mais aventuras cúbicas!
                }
            }
        }
    }
            //// Desenhar item equipado e checar clique para desequipar
            //if (global.item_player) {
            // draw_sprite_ext(global.item_player.spr, global.item_player.frames, 1016, 582, 2, 2, 0, c_white, 1);
            // // Checar clique na área do item equipado (tamanho aprox. 32x32 com escala=2)
            // if point_in_rectangle(_mx, _my, 1016, 582, 1016 + 32, 582 + 32) {
            // if mouse_check_button_released(mb_left) && !global.item_mouse {
            // // Tenta adicionar o item equipado de volta ao inventário
            // if (adiciona_ao_inventario(global.item_player.id, 1)) {
            // global.item_player = noone; // Desequipa
            // }
            // }
            // }
            //}
            // Criando um loop for para definir os slots
            var ix = 0; // Essas variáveis servem para qualquer slot no x e no y do inventário começarem no ponto 0
            var iy = 0;
    
            for (var i = 0; i < total; i++) {
                // Calculando as coordenadas para desenhar cada slot do inventário
                var _slotsx = _invx + comeco_x + ((tamanho_slot + buffer) * ix);
                var _slotsy = _invy + comeco_y + ((tamanho_slot + buffer) * iy);
        
                // Verificando se o mouse está sobre o slot atual
                if point_in_rectangle(_mx, _my, _slotsx, _slotsy, _slotsx + tamanho_slot, _slotsy + tamanho_slot) {
                    // Desenhando um seletor no slot se o mouse estiver sobre ele
                    draw_sprite_ext(spr_inventario_seletor, 0, _slotsx, _slotsy, escala, escala, 0, c_white, 1);
                }
        
                //checando se na minha selecão atual existe algum item
                var _slot = encontra_item(ix, iy);
                //se a seleção atual possui um valor que nao seja nulo
                //entao eu tenho algum item
                if (_slot) {
                    var _item_atual = global.itens[| _slot.id];
                    var _item_atual_x = _slotsx;
                    var _item_atual_y = _slotsy;
                    //desenhar a sprite do item com frame correto
                    draw_sprite_stretched(_item_atual.spr, _item_atual.frames, _item_atual_x, _item_atual_y, tamanho_slot, tamanho_slot);
            
                    // Desenhe a quantidade se >1 (no canto inferior direito do slot)
                    if (_slot.quantity > 1) {
                        draw_set_font(fnt_dialogo_small); // Use uma font pequena se necessário
                        draw_set_color(c_white);
                        draw_text(_item_atual_x + tamanho_slot - 16, _item_atual_y + tamanho_slot - 16, string(_slot.quantity));
                        draw_set_font(-1);
                    }
                }
                        
                // Verificando se o mouse está sobre o slot atual para descrição
                if point_in_rectangle(_mx, _my, _slotsx, _slotsy, _slotsx + tamanho_slot, _slotsy + tamanho_slot) {
                    // Verificar se há um item no slot sob o cursor
                    var _sel_slot = encontra_item(ix, iy);
                    // Se houver um item no slot, desenhar a sprite e a descrição
                    if (_sel_slot) {
                        var _sel_atual = global.itens[| _sel_slot.id];
                        //variavel pro efeitinho da sprite
                        var _efeitox = sin(get_timer() / 1000000);
                        draw_sprite_stretched(_sel_atual.spr, _sel_atual.frames, x + 178, y + 338, 60, 60);
                        // Desenhar a descrição do item
                        draw_set_font(fnt_desc_inventario);
                        draw_set_color(c_black);
                        draw_text_ext(x + 153, y + 416, _sel_atual.desc, 25, 100);
                        draw_set_color(c_white);
                        draw_text_ext(x + 152, y + 415, _sel_atual.desc, 25, 100);
                        draw_set_font(-1);
                    }
                }
        
                // Interações com mouse
                if point_in_rectangle(_mx, _my, _slotsx, _slotsy, _slotsx + tamanho_slot, _slotsy + tamanho_slot) {
                    var _slot = encontra_item(ix, iy);
                    if mouse_check_button_released(mb_right) && !global.item_mouse { // Só split se mouse vazio
                        if (_slot) {
                            var _item = global.itens[| _slot.id];
                            if (_slot.quantity > 1 && _item.max_stack > 1) {
                                global.item_mouse = split_item(ix, iy); // Split metade
                            } else {
                                if (_item.tipo == TIPO_ITENS.armamento) {
                                    // Desequipar o atual se houver
                                    if (global.item_player != noone) {
                                        adiciona_ao_inventario(global.item_player.id, 1);
                                        global.item_player = noone;
                                    }
                                    _item.usa_item(); // Equipa o novo
                                    // Remove do slot (já que armamento max_stack=1)
                                    global.inventario_slots[# ix, iy] = 0;
                                } else if (_item.tipo == TIPO_ITENS.consumivel) {
                                    // Lógica de usar consumível (ex: aplicar efeito, por agora só diminui qtd)
                                    _item.usa_item();
                                    if (_slot.quantity > 1) {
                                        _slot.quantity -= 1;
                                    } else {
                                        global.inventario_slots[# ix, iy] = 0;
                                    }
                                }
                                // Para materiais: Nada extra, não equipa
                            }
                        }
                    }
                    if mouse_check_button_released(mb_left) {
                        global.item_mouse = troca_item(ix, iy, global.item_mouse); // Troca ou junta
                    }
                }
        // Drop com "D" só se não estiver equipado
                if point_in_rectangle(_mx, _my, _slotsx, _slotsy, _slotsx + tamanho_slot, _slotsy + tamanho_slot) {
                    var _slot = encontra_item(ix, iy);
                    if (_slot && keyboard_check_pressed(ord("D"))) {
                        var _item = global.itens[| _slot.id];
                        if (_item != global.item_player) { // Só dropa se não estiver equipado
                            var _sdash_x = obj_sdash.x;
                            var _sdash_y = obj_sdash.y;
                            var _drop_x = _sdash_x + random_range(-20, 20); // Dropa perto com variação
                            var _drop_y = _sdash_y + random_range(-20, 20);
                            var _novo_drop = instance_create_layer(_drop_x, _drop_y, "Instances", obj_drop);
                            _novo_drop.meu_id = _slot.id;
                            _novo_drop.sprite_index = _item.spr; // Definir sprite diretamente
                            _novo_drop.image_index = _item.frames; // Definir frame diretamente
                            _novo_drop.qtd = _slot.quantity;
                            global.inventario_slots[# ix, iy] = 0; // Remove do slot
                            if (_item.tipo == TIPO_ITENS.material) {
                                _novo_drop.sprite = _item.spr;
                            }
                        }
                    }
                }
                if (global.item_mouse) { //se tem um item no mouse ele desenha
                    var _item_mouse = global.itens[| global.item_mouse.id];
                    draw_sprite_ext(_item_mouse.spr, _item_mouse.frames, _mx, _my, 2, 2, 0, c_white, 0.8);
                }
                // Atualizando as coordenadas para o próximo slot
                ix++;
                if ix >= slot_h { //ele pula pro proximo slot (ou seja ele reseta a horizontal e soma mais um na vertical)
                    ix = 0;
                    iy++;
                }
            }
        }
}
desenha_menu_construcao = function() {
    if (inventario) {
        var _guil = display_get_gui_width();
        var _guia = display_get_gui_height();
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        static _margens = [0, 0]; // Margens pra cada botão
        var x1 = x + 496;
        var y1 = y + 85;
        var x2 = _guil - 500;
        var y2 = _guia - 520;
        var _esc = 2;
        var _spr_w = 107 * _esc;
        var _spr_h = 34 * _esc;
        var _mouse_sobre = noone;
        var _mouse_click = mouse_check_button_pressed(mb_left);
        var _lista_construcao = [ spr_botao_construcao2, spr_botao_construcao3];
        var _qtd = array_length(_lista_construcao);
        var _tam_margem = array_length(global.itens_construcao[global.menu_construcao]) + _spr_h + _spr_h;
        var meio = (y1 + y2) / 2;
        draw_rectangle(x1, y1, x2, meio, 1);
        draw_rectangle(x1, meio, x2, y2, 1);
        // Removido draw redundante de spr_botao_construcao2 fora do loop
        for (var _i = 0; _i < _qtd; _i++) {
            var _cor = c_white;
            var _x_inicio = x1 + 60;
            var _y_inicio = y1 + _i * _spr_h + _margens[_i];
            var _x2 = _x_inicio + _spr_w;
            var _y2 = _y_inicio + _spr_h;
            var _spr = _lista_construcao[_i];
            _mouse_sobre = point_in_rectangle(_mx, _my, _x_inicio, _y_inicio, _x2, _y2);
            if (_mouse_sobre) {
                _cor = c_yellow;
                if (_mouse_click) {
                    if (global.menu_construcao == _i + 1) {
                        global.menu_construcao = LISTA_CONSTRUCAO.fechado; // Fecha se clicar de novo
                    } else {
                        global.menu_construcao = _i + 1; // Abre o menu
                    }
                    // Resetar margens pra evitar acumulo
                    _margens = [0, 0];
                }
            }
            // Ajustar margens só pro botão aberto, exceto pro último (não precisa expandir abaixo)
            if (global.menu_construcao == _i + 1 && _i < _qtd - 1) { // Não expande o último botão
                _margens[_i] = lerp(_margens[_i], _tam_margem, 0.2); // Aumenta margem pro botão aberto, criando espaço abaixo
            } else {
                _margens[_i] = lerp(_margens[_i], 0, 0.2); // Reduz margem pros outros
            }
            draw_sprite_ext(_spr, 0, _x_inicio, _y_inicio, _esc, _esc, 0, _cor, 1);
        }
        // Chamar desenha_itens_construcao abaixo do botão aberto
        if (global.menu_construcao != LISTA_CONSTRUCAO.fechado) {
            var _index_botao = global.menu_construcao - 1; // Index do botão aberto
            var _y_itens = y1 + _index_botao * _spr_h + _margens[_index_botao] + _spr_h + 5; // Abaixo do botão aberto, com espaço
            var _itens = global.itens_construcao[global.menu_construcao];
            desenha_itens_construcao(_x_inicio, _y_itens, _itens);
        }
    }
};
desenha_itens_construcao = function(_x_inicio, _y_inicio, _array, _spr = spr_botao_construcao2) {
    var _qtd = array_length(_array);
    var _esc = 1.7;
    var _spr_w = sprite_get_width(_spr) * _esc;
    var _spr_h = sprite_get_height(_spr) * _esc;
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _mouse_click = mouse_check_button_pressed(mb_left);
    var _esp = 5;
    for (var _i = 0; _i < _qtd; _i++) {
        var _atual = _array[_i];
        var _txt = is_struct(_atual) ? _atual.nome : "???";
        var _x = _x_inicio;
        var _y = _y_inicio + _i * (_spr_h + _esp) + _esp;
        var _x2 = _x + _spr_w;
        var _y2 = _y + _spr_h;
        var _cor = point_in_rectangle(_mx, _my, _x, _y, _x2, _y2) ? c_aqua : c_white;
        if (_cor == c_aqua) {
            if (is_struct(_atual)) _atual.desenha_info(_x, _y2);
            if (_mouse_click) {
                switch (_i) {
                    case LISTA_FORGE.fornalha:
                        if (tem_materiais(_atual)) {
                            // Materiais so sao consumidos quando a colocacao for confirmada.
                            var _place = instance_create_layer(mouse_x, mouse_y, "Instances", obj_place);
                            _place.estrutura = _atual;
                            _place.build_kind = "fornalha";

                            instance_create_depth(obj_sdash.x, obj_sdash.y, depth - 10, obj_brilho);
                            tocar_som_efeito(snd_blip_2, 8, 1);

                            inventario = false;
                            global.pause = false;
                            global.pause_por_inventario = false;
                        } else {
                            gc_quest_toast("Materiais insuficientes", 100);
                        }
                    break;

                    default:
                        // Evita o bug antigo onde Mesa criava uma Fornalha.
                        gc_quest_toast(_atual.nome + " ainda nao possui objeto de mundo", 140);
                    break;
                }
           }
        }
        draw_sprite_ext(_spr, 0, _x, _y, _esc, _esc, 0, _cor, 1);
        var tw = string_width(_txt);
        var th = string_height(_txt);
        draw_text(_x + (_spr_w - tw)/2, _y + (_spr_h - th)/2 - 4, _txt);
    }
};
#endregion