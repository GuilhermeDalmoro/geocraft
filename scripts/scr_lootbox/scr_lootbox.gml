// ==============================================
//  SISTEMA DE BAÚS & INSÍGNIAS – Geocraft
//  (versão consolidada – tudo em um lugar)
// ==============================================

// 1. Enum + Structs principais
enum INSIGNIA_TIPO {
    honra,
    coragem,
    fama,
    sombra,
    amizade,
    // pode adicionar mais depois
}

function Insignia(_nome, _tipo, _desc, _efeito_nome, _valor, _cor, _frame_index) constructor {
    nome          = _nome;
    tipo          = _tipo;
    desc          = _desc;
    efeito_nome   = _efeito_nome;
    valor         = _valor;
    cor           = _cor;
    frame_index   = _frame_index;     // ← o frame dentro de spr_insignia_1
    estrela = 0;
}

global.insignias = [
    new Insignia("Honra do Cubo",      INSIGNIA_TIPO.honra,   "Os aldeões confiam mais em você",           "Reputação +",   1.0, c_lime,   0),   // frame 0
    new Insignia("Coração Valente",    INSIGNIA_TIPO.coragem, "Enfrenta o perigo sem piscar",               "Dano em risco +", 0.20, c_orange, 1),   // frame 1
    new Insignia("Lenda Rosa",         INSIGNIA_TIPO.fama,    "Todo mundo já ouviu falar de Sdash",         "Preço nas lojas -", 0.25, c_yellow, 2),  // frame 2
    new Insignia("Sombra do Cowboy",   INSIGNIA_TIPO.sombra,  "Você faz o que precisa ser feito…",          "Dano furtivo +", 0.30, c_purple, 3),   // frame 3
    new Insignia("Amigo da Geleia",    INSIGNIA_TIPO.amizade, "Sabe conquistar corações (e geleias)",       "Chance de presente +", 0.15, c_red,  4),   // frame 4
    // adicione mais frames conforme o sprite tiver
];

// Variáveis globais de estado (persistentes)
if (!variable_global_exists("insignias_adquiridas")) {
    global.insignias_adquiridas = ds_list_create();
}
global.reputacao      = 0;
global.mod_dano_risco = 1.0;
global.mod_preco      = 1.0;   // menor = mais barato
// etc...

// ==============================================
// 2. Função auxiliar – aplicar insígnia escolhida
// ==============================================
function aplicar_insignia(_ins) {
    switch(_ins.tipo) {
        case INSIGNIA_TIPO.honra:
            global.reputacao += _ins.valor;
            break;
            
        case INSIGNIA_TIPO.coragem:
            global.mod_dano_risco += _ins.valor;
            break;
            
        case INSIGNIA_TIPO.fama:
            global.mod_preco *= (1 - _ins.valor);
            break;
            
        case INSIGNIA_TIPO.sombra:
            // ex: aumenta dano, mas diminui reputação
            global.mod_dano_risco += _ins.valor * 0.5;
            global.reputacao -= _ins.valor * 0.8;
            break;
            
        case INSIGNIA_TIPO.amizade:
            // chance de NPCs darem itens extras
            global.chance_presente += _ins.valor;
            break;
    }
    
    // Efeito visual no Sdash (brilho temporário na cor da insígnia)
    with (obj_sdash) {
        cor_brilho = _ins.cor;
        tempo_brilho = 180;     // 3 segundos @ 60 fps
    }
    
    // Som épico
    //audio_play_sound(snd_insignia_ganha, 10, false);
}