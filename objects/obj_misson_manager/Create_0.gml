//show_message("Gerenciador de missões iniciado");

global.missoes = scr_missoes_banco();

//show_message("Missões carregadas:");
//show_message(global.missoes[0].id_m);

var _m = scr_missoes_pegar("teste");

scr_missoes_iniciar(_m);

if (_m != noone) {
    //show_message("Missão encontrada: " + _m.nome);
} else {
    //show_message("Missão NÃO encontrada");
    }