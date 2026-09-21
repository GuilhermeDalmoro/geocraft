// Alarm 0 Event
if (inicializar) {
    global.pause = true;
    global.dialogo_acontecendo = true;
    
    if (caractere < string_length(texto_grid[# Infosnpc.Texto, pagina])) {
        var _char = string_char_at(texto_grid[# Infosnpc.Texto, pagina], caractere + 1);
        var _is_abalo = false;
       
        // Verifica se o caractere atual tá numa palavra com [abalo]
        var _texto_atual = string_copy(texto_grid[# Infosnpc.Texto, pagina], 1, caractere + 1);
        for (var i = 0; i < array_length(palavras); i++) {
            if (string_pos(palavras[i], _texto_atual) > 0 && efeitos[i].tipo == "abalo") {
                _is_abalo = true;
                break;
            }
        }
       
        if (_char != "." && _char != "," && _char != "-") { 
            caractere++;
            alarm[0] = 1;
        } else {
            alarm[0] = 15;
            
            caractere++;
        }
    }
}