enum Infosnpc {
    Texto,
    Retrato,
    Lado,
    Nome
}

npc_nome = "";
npc_ref = noone
texto_grid = ds_grid_create(4, 0);
pagina = 0;
opcao[0] = "";
opcao_resposta[0] = "";
opcao_numero = 0;
opcao_selecionado = 0;
opcao_draw = false;
inicializar = false;
caractere = 0;
alarm[0] = 1;
palavras = [];
efeitos = [];