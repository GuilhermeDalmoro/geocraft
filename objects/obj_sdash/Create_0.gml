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
    var _click = mouse_check_button(mb_left);
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

//XP
xp = 0;
insignia = 0;
max_xp[1] = 100;
max_xp[2] = 110;
max_xp[3] = 120;
max_xp[4] = 130;
max_xp[5] = 140;
max_xp[6] = 150;
max_xp[7] = 160;
max_xp[8] = 170;
max_xp[9] = 180;
max_xp[10] = 200;
max_xp[11] = 230;
max_xp[12] = 260;
max_xp[13] = 280;
max_xp[14] = 300;
max_xp[15] = 320;
max_xp[16] = 340;
max_xp[17] = 380;
max_xp[18] = 400;
max_xp[19] = 410;
max_xp[20] = 420;
max_xp[21] = 430;
max_xp[22] = 440;
max_xp[23] = 450;
max_xp[24] = 460;
max_xp[25] = 480;
max_xp[26] = 500;

//raio
raio_range   = 100;   // alcance pra procurar inimigos
raio_cd_max  = 30;    // 30 frames ~ 0.5s a 60fps
raio_cd      = 0;     // contador do cooldown
raio_dano    = 2;     // dano do raio

// efeito visual simples do raio
ray_fx_timer = 0;
ray_fx_x1 = 0; ray_fx_y1 = 0; // origem (Sdash)
ray_fx_x2 = 0; ray_fx_y2 = 0; // destino (inimigo)

raio_ligado = true; // deixa true pra já ficar ativo quando selecionado



#endregion