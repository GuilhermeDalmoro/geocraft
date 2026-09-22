if (!inicializar) {
    // Chama o script correto baseado no idioma
    if (global.lingua == "pt-br") script_execute(scr_textos);
    else script_execute(scr_textos_en);
    
    inicializar = true;
    alarm[0] = 1;
    global.pause = true;
   
    //// =============================================
    //// NOVO: Sdash tem som padrão EXCLUSIVO dele automaticamente!
    //// (porque ele não é NPC, é o herói que chama o diálogo)
    //// =============================================
    //if (ds_grid_height(texto_grid) > 0) {
        //var _speaker = texto_grid[# Infosnpc.Nome, 0];  // pega o nome da primeira página do diálogo
        //
        //if (string_lower(_speaker) == "Sdash" || string_pos("Sdash", string_lower(_speaker)) == 1) {
            //sons = global.sdash_sons;  // usa os sons rosa bebê do cowboy!
        //}
    //}
   
    // Parsear texto e criar palavras com efeitos (seu código original)
    var _texto = texto_grid[# Infosnpc.Texto, pagina];
    palavras = [];
    efeitos = [];
    var _current = "";
    var _efeito = { tipo: "nenhum", cor: c_white };
    var _in_tag = false;
    var _tag = "";
   
    for (var i = 1; i <= string_length(_texto); i++) {
        var _char = string_char_at(_texto, i);
        if (_char == "[") {
            _in_tag = true;
            _tag = "";
            continue;
        }
        if (_char == "]" && _in_tag) {
            _in_tag = false;
            if (_tag == "semefeito") _efeito = { tipo: "nenhum", cor: c_white };
            else if (string_pos("tremor", _tag) == 1) _efeito.tipo = string_pos("/tremor", _tag) == 0 ? "tremor" : "nenhum";
            else if (string_pos("bounce", _tag) == 1) _efeito.tipo = string_pos("/bounce", _tag) == 0 ? "bounce" : "nenhum";
            else if (string_pos("pulsar", _tag) == 1) _efeito.tipo = string_pos("/pulsar", _tag) == 0 ? "pulsar" : "nenhum";
            else if (string_pos("onda", _tag) == 1) _efeito.tipo = string_pos("/onda", _tag) == 0 ? "onda" : "nenhum";
            else if (string_pos("abalo", _tag) == 1) _efeito.tipo = string_pos("/abalo", _tag) == 0 ? "abalo" : "nenhum";
            else if (string_pos("flutuar", _tag) == 1) _efeito.tipo = string_pos("/flutuar", _tag) == 0 ? "flutuar" : "nenhum";
            else if (string_pos("zoom", _tag) == 1) _efeito.tipo = string_pos("/zoom", _tag) == 0 ? "zoom" : "nenhum";
            else if (string_pos("cor=", _tag) == 1) {
                var _cor = string_replace(_tag, "cor=", "");
                if (_cor == "vermelho") _efeito.cor = c_red;
                else if (_cor == "azul") _efeito.cor = c_blue;
                else if (_cor == "amarelo") _efeito.cor = c_yellow;
                else if (_cor == "roxo") _efeito.cor = c_purple;
                else if (_cor == "laranja") _efeito.cor = c_orange;
                else if (_cor == "verde") _efeito.cor = c_green;
                else if (_cor == "/cor") _efeito.cor = c_white;
            }
            continue;
        }
        if (_in_tag) {
            _tag += _char;
            continue;
        }
        if (_char == " " || i == string_length(_texto)) {
            if (i == string_length(_texto)) _current += _char;
            if (_current != "") {
                array_push(palavras, _current);
                array_push(efeitos, { tipo: _efeito.tipo, cor: _efeito.cor });
                _current = "";
            }
            if (_char == " ") {
                array_push(palavras, " ");
                array_push(efeitos, { tipo: "nenhum", cor: c_white });
            }
        } else _current += _char;
    }
}
// Resto do código (páginas, opções) mantém igual
if (caractere < string_length(texto_grid[# Infosnpc.Texto, pagina])) {
    if (keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(global.controle, gp_face1)) {
        caractere = string_length(texto_grid[# Infosnpc.Texto, pagina]);
    }
} else {
    if (pagina < ds_grid_height(texto_grid) - 1) {
        if (keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(global.controle, gp_face1)) {
            alarm[0] = 1;
            caractere = 0;
            pagina++;
            var _texto = texto_grid[# Infosnpc.Texto, pagina];
            palavras = [];
            efeitos = [];
            var _current = "";
            var _efeito = { tipo: "nenhum", cor: c_white };
            var _in_tag = false;
            var _tag = "";
            for (var i = 1; i <= string_length(_texto); i++) {
                var _char = string_char_at(_texto, i);
                if (_char == "[") {
                    _in_tag = true;
                    _tag = "";
                    continue;
                }
                if (_char == "]" && _in_tag) {
                    _in_tag = false;
                    if (_tag == "semefeito") _efeito = { tipo: "nenhum", cor: c_white };
                    else if (string_pos("tremor", _tag) == 1) _efeito.tipo = string_pos("/tremor", _tag) == 0 ? "tremor" : "nenhum";
                    else if (string_pos("bounce", _tag) == 1) _efeito.tipo = string_pos("/bounce", _tag) == 0 ? "bounce" : "nenhum";
                    else if (string_pos("pulsar", _tag) == 1) _efeito.tipo = string_pos("/pulsar", _tag) == 0 ? "pulsar" : "nenhum";
                    else if (string_pos("onda", _tag) == 1) _efeito.tipo = string_pos("/onda", _tag) == 0 ? "onda" : "nenhum";
                    else if (string_pos("abalo", _tag) == 1) _efeito.tipo = string_pos("/abalo", _tag) == 0 ? "abalo" : "nenhum";
                    else if (string_pos("flutuar", _tag) == 1) _efeito.tipo = string_pos("/flutuar", _tag) == 0 ? "flutuar" : "nenhum";
                    else if (string_pos("zoom", _tag) == 1) _efeito.tipo = string_pos("/zoom", _tag) == 0 ? "zoom" : "nenhum";
                    else if (string_pos("cor=", _tag) == 1) {
                        var _cor = string_replace(_tag, "cor=", "");
                        if (_cor == "vermelho") _efeito.cor = c_red;
                        else if (_cor == "azul") _efeito.cor = c_blue;
                        else if (_cor == "amarelo") _efeito.cor = c_yellow;
                        else if (_cor == "roxo") _efeito.cor = c_purple;
                        else if (_cor == "laranja") _efeito.cor = c_orange;
                        else if (_cor == "verde") _efeito.cor = c_green;
                        else if (_cor == "/cor") _efeito.cor = c_white;
                    }
                    continue;
                }
                if (_in_tag) {
                    _tag += _char;
                    continue;
                }
                if (_char == " " || i == string_length(_texto)) {
                    if (i == string_length(_texto)) _current += _char;
                    if (_current != "") {
                        array_push(palavras, _current);
                        array_push(efeitos, { tipo: _efeito.tipo, cor: _efeito.cor });
                        _current = "";
                    }
                    if (_char == " ") {
                        array_push(palavras, " ");
                        array_push(efeitos, { tipo: "nenhum", cor: c_white });
                    }
                } else _current += _char;
            }
        }
    } else {
        if (opcao_numero != 0) opcao_draw = true;
        else if (keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(global.controle, gp_face1)) {
            // O Quest System recebe o nome do dialogo/NPC sem mudar o conteudo do dialogo.
            gc_quest_notify("falar", npc_nome, 1);

            if (instance_exists(npc_ref)) {
                npc_ref.terminou_dialogo = true;

                if (variable_instance_exists(npc_ref, "nome")) {
                    gc_quest_notify("falar", string(npc_ref.nome), 1);
                }
            }

            instance_destroy();
            global.pause = false;
            global.dialogo_acontecendo = false;
            // if (global.comeca_batalha) {
            // if (global.turno == 0) {
            // global.batalha_menu = 0; // Ativa menu após diálogo do jogador
            // } else if (global.turno == 1) {
            // global.batalha_menu = -1; // Mantém desativado pro ataque do inimigo
            // }
            //}
        }
    }
}