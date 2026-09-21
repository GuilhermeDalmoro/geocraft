#region Equipamentos
// enumerator armas
enum ARMAS{
    Espada,
    Arco ,
    Cajado,
    Altura
}

ferramenta = noone;
usando_ferramenta = false;
ferramenta_selecionada = false;
meu_brilho = new efeito_brilho() ;

usa_ferramenta = function() {
    var _click = mouse_check_button(mb_left) or gamepad_axis_value(global.controle, gp_shoulderrb);
        if (usando_ferramenta == false) {
            if (_click) {
    if (meu_seletor.alvo){
        with(meu_seletor.alvo){
    aplica_boing(2 , .5);
    meu_brilho.inicia_brilho();
    perde_vida();
    }
}
            usando_ferramenta = true;
        }
    } else {
        usando_ferramenta = ferramenta.golpe();
        if (!ferramenta.sendo_usada) usando_ferramenta = false; // Reseta após o golpe
    }
}
segura_ferramenta = function() {
    if (!ferramenta) exit;
    ferramenta.visible = ferramenta_selecionada; // Só aparece se selecionada
    if (ferramenta_selecionada) {
        usa_ferramenta();
        ferramenta.x = x;
        ferramenta.y = y + 5;
        ferramenta.depth = depth - 5;
        if (dir == 2) { ferramenta.image_xscale = -1; } else { ferramenta.image_xscale = 1; }
    }
}
seletor = function(){
var _prox = instance_nearest(x, y, obj_mineravel);
//verificando se existe um proximo pra ser procurado
if(_prox && instance_exists(meu_seletor) && ferramenta_selecionada){
    var _dist = point_distance(x, y, _prox.x, _prox.y);
    if _dist< 32{
    meu_seletor.x = _prox.x;
    meu_seletor.y = _prox.y;
    global.seletor_visivel = true;
}else{
    global.seletor_visivel = false;
}
    
}else if !_prox{
    global.seletor_visivel = false;
    }
}

ferramenta = instance_create_depth(x, y, depth, obj_picareta);
meu_seletor = instance_create_depth(x, y, depth, obj_seletor); 

#endregion

#region Variaveis

morrendo = false;
timer_morte = 0;

//Movimentação
direita = -1;
cima = -1;
esquerda = -1;
baixo = -1;
hveloc = 0;
vveloc = 0;
veloc = 2;
veloc_dir = -1;
seq_atual_arma = noone;
dir = 0;

//Dash
dash_dir = -1;
dash_veloc = 6;

//Estado
estado = scr_sdash_correndo;
inimigos_atingidos = ds_list_create();
active = true; //controla se o sdash esta ativo
pode_andar = true
visible = true;

//Combate
max_estamina = 120;
estamina = max_estamina;
max_vida = 10;
vida = max_vida;
tomardano = true;
empurrar_dir = 0;
dano = 1;
atacar = false;
dano_alfa = -1;

//armas do sdash
arma = 0;

//Magias
magia_cooldown = 0;

//fade in da transicao
fade_alpha = 0;
fade_estado = 0;
fade_vel = 0.03;

//cavalos
montado = false;
meu_cavalo = noone;

//sons do sdash
global.sdash_sons = [snd_ihu_intro, snd_blip_2, snd_blip_select, snd_blim]

#endregion

//JUKEBOX
//o sdash é um listener

audio_listener_orientation(0, 0, 1, 0, -1, 0);