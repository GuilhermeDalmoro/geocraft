#region funções

function fim_da_animacao(){//nao fui eu que escrevi essa função acima!
var _sprite = sprite_index;
	var _image = image_index;
	if(argument_count > 0) _sprite = argument[0];
	if(argument_count > 1) _image = argument[1];
	var _type = sprite_get_speed_type(sprite_index);
	var _spd = sprite_get_speed(sprite_index)*image_speed;
	if(_type == spritespeed_framespersecond)
	    _spd = _spd/room_speed;
	if(argument_count > 2) _spd = argument[2];
	return _image + _spd >= sprite_get_number(_sprite);
}

function resetar_camera() {
    var _cam = view_camera[0]; // Obtém a câmera ativa (view 0)
    var _default_width =  334;  // Largura padrão
	var _default_height = 192; // Altura padrão
   camera_set_view_size(_cam, _default_width, _default_height); // Restaura o tamanho
}
	
function setar_camera(){
		var _cam = view_camera[0]; // Obtém a câmera ativa (view 0)
		var _new_width = 509;     // Nova largura
		var _new_height = 288;     // Nova altura

	   camera_set_view_size(_cam, _new_width, _new_height); // Altera o tamanho
}
	
function cria_brilho(_x, _y, _cor) {
    var _inst = instance_create_depth(_x, _y, depth - 10, obj_brilho);
    _inst.image_blend = _cor;
    return _inst;
}
	

function drop_moedas(_x, _y, _min, _max) {
    var num_moedas = irandom_range(_min, _max);

    for (var i = 0; i < num_moedas; i++) {
		//var num = irandom_range(-1,100)
        var x_offset = irandom_range(-25, 30);
        var y_offset = irandom_range(-20, 35);

        var _inst = instance_create_layer(_x + x_offset, _y + y_offset, "Instances", obj_moeda);
        _inst.image_xscale = 0.2;
        _inst.image_yscale = 0.2;
    }
}

function draw_text_colour_outline(){
    //Created by Andrew McCluskey http://nalgames.com/
 
    ///@arg x
    ///@arg y
    ///@arg str
    ///@arg outwidth
    ///@arg outcol
    ///@arg outfidelity
    ///@arg separation
    ///@arg width
 
 
    //2,c_dkgray,4,20,500 <Personal favorite preset. (For fnt_3)
    var dto_dcol = draw_get_color();
 
    draw_set_color(argument4);
 
    for(var dto_i=45; dto_i<405; dto_i+=360/argument5)
    {
      //draw_text_ext(argument0+lengthdir_x(argument3,dto_i),argument1+lengthdir_y(argument3,dto_i),argument2,argument6,argument7);
      draw_text_ext(argument0+round(lengthdir_x(argument3,dto_i)),argument1+round(lengthdir_y(argument3,dto_i)),argument2,argument6,argument7);
    }
 
    draw_set_color(dto_dcol);
 
    draw_text_ext(argument0,argument1,argument2,argument6,argument7);
}

function create_particle_effect(_x, _y, _type, _duration, _color = c_purple, _size = 5, _direction = -1, _speed = 2, _count = 1) {
    for (var i = 0; i < _count; i++) {
        var _part = instance_create_layer(_x + random_range(-10, 10), _y + random_range(-10, 10), "Instances", obj_part);
        with (_part) {
            vida = _duration;
            image_alpha = 1;
            switch (_type) {
                case "explosion":
                    sprite_index = spr_part_explosao;
                    image_speed = 0.5;
                    image_xscale = _size / 10;
                    image_yscale = _size / 10;
                    direction = random(360); // Espalha em todas as direções
                    speed = _speed * random_range(0.8, 1.2); // Variação de velocidade
                    break;
                case "trail":
                    sprite_index = spr_part_trail;
                    direction = (_direction == -1) ? random(360) : _direction + random_range(-15, 15); // Variação leve
                    speed = _speed;
                    image_xscale = _size / 5;
                    image_yscale = _size / 5;
                    break;
                case "rain":
                    sprite_index = spr_part_chuva;
                    direction = 270 + random_range(-10, 10); // Leve variação na chuva
                    speed = _speed;
                    image_xscale = _size / 10;
                    image_yscale = _size / 10;
                    break;
                case "spark":
                    sprite_index = spr_part_faisca;
                    direction = (_direction == -1) ? random(360) : _direction + random_range(-20, 20);
                    speed = _speed * 1.5;
                    image_xscale = _size / 15;
                    image_yscale = _size / 15;
                    break;
            }
            image_blend = _color;
        }
    }
}

function move_object(_obj, _target_x, _target_y, _speed) {
    with (_obj) {
        // Calcula a direção e distância
        var _dir = point_direction(x, y, _target_x, _target_y);
        var _dist = point_distance(x, y, _target_x, _target_y);
        
        // Move na direção com a velocidade definida
        if (_dist > 0) {
            var _move_x = lengthdir_x(_speed, _dir);
            var _move_y = lengthdir_y(_speed, _dir);
            x += _move_x;
            y += _move_y;
            
            // Corrige overshooting
            if (_dist < _speed) {
                x = _target_x;
                y = _target_y;
            }
        }
    }
}

function suavizar(_de, _para, _vel){
	return lerp(_de, _para, clamp(_vel * delta_time, 0, 1));
}

function tocar_musica(_musica) {
    if (!audio_is_playing(_musica)) {
        audio_stop_all();
        audio_play_sound(_musica, 1, true);
    }
}

function mouse_hover(_obj){
	return position_meeting(mouse_x, mouse_y, _obj);
}

function tocar_som_efeito(_som, _volume, _pitch) {
    if (!audio_is_playing(_som)) {
        audio_play_sound(_som, 1, false);
        audio_sound_gain(_som, _volume, 0);
        audio_sound_pitch(_som, _pitch);
    }
}

function mover_ate_alvo(_obj, _alvo_x, _alvo_y, _velocidade) {
    with (_obj) {
        var _dir = point_direction(x, y, _alvo_x, _alvo_y);
        var _dist = point_distance(x, y, _alvo_x, _alvo_y);
        if (_dist > 0) {
            var _move_x = lengthdir_x(min(_velocidade, _dist), _dir);
            var _move_y = lengthdir_y(min(_velocidade, _dist), _dir);
            x += _move_x;
            y += _move_y;
        }
    }
}

function gerar_texto_flutuante(_x, _y, _texto, _cor, _duracao, _camada) {
    with (instance_create_layer(_x, _y, _camada, obj_texto_flutuante)) {
        texto = _texto;
        cor = _cor;
        vida = _duracao;
        y_speed = -1; // Subir
    }
}

function mudar_cor_objeto(_obj, _cor) {
    with (_obj) {
        image_blend = _cor;
    }
}

function definir_escala_objeto(_obj, _escala_x, _escala_y) {
    with (_obj) {
        image_xscale = _escala_x;
        image_yscale = _escala_y;
    }
}

function mudar_cor_gradual(_cor_alvo, _duracao) {
    if (!variable_instance_exists(id, "cor_inicial")) cor_inicial = image_blend;
    if (!variable_instance_exists(id, "tempo_transicao")) tempo_transicao = 0;
    
    tempo_transicao = min(tempo_transicao + 1, _duracao);
    var _fator = tempo_transicao / _duracao;
    image_blend = merge_color(cor_inicial, _cor_alvo, _fator);
    
    if (tempo_transicao == _duracao) {
        cor_inicial = _cor_alvo;
        tempo_transicao = 0;
    }
}
	
function ajustar_escala_gradual(_obj, _escala_x, _escala_y, _duracao) {
    if (!variable_instance_exists(id, "escala_inicial_x")) escala_inicial_x = image_xscale;
    if (!variable_instance_exists(id, "escala_inicial_y")) escala_inicial_y = image_yscale;
    if (!variable_instance_exists(id, "tempo_transicao")) tempo_transicao = 0;
    
    tempo_transicao = min(tempo_transicao + 1, _duracao);
    var _fator = tempo_transicao / _duracao;
    _obj.image_xscale = lerp(escala_inicial_x, _escala_x, _fator);
   _obj.image_yscale = lerp(escala_inicial_y, _escala_y, _fator);
    
    if (tempo_transicao == _duracao) {
        escala_inicial_x = _escala_x;
        escala_inicial_y = _escala_y;
        tempo_transicao = 0;
    }
}	
	
function tremer_objeto(_intensidade, _duracao) {
    if (!variable_instance_exists(id, "tremor_tempo")) tremor_tempo = 0;
		if (tremor_tempo < _duracao) {
		    x += random_range(-_intensidade, _intensidade);
		    y += random_range(-_intensidade, _intensidade);
		    tremor_tempo += 1;
			    } else {
			        x = xprevious;
			        y = yprevious;
			        tremor_tempo = 0;
			    }
}
	

function draw_glow_effect(_sprite, _subimg, _x, _y, _xscale, _yscale, _rot, _color, _intensity, _radius, _pulse) {
	/// @function draw_glow_effect(sprite, subimg, x, y, xscale, yscale, rot, color, intensity, radius, pulse)
/// @description Desenha uma aura de glow luminosa ao redor de um sprite. Use no evento Draw de objetos.
/// @param {sprite} sprite O sprite a ser desenhado com glow.
/// @param {real} subimg Subimagem do sprite.
/// @param {real} x Posição X.
/// @param {real} y Posição Y.
/// @param {real} xscale Escala X.
/// @param {real} yscale Escala Y.
/// @param {real} rot Rotação.
/// @param {color} color Cor do glow (ex.: c_pink pro Sdash).
/// @param {real} intensity Intensidade do glow (0-1, ex.: 0.8 pra brilho forte).
/// @param {real} radius Raio da aura (ex.: 8 pixels pra cubos pequenos).
/// @param {bool} pulse Se true, faz o glow pulsar como um coração cúbico.

    // Configura blend mode pra glow aditivo (faz brilhar sem escurecer o fundo)
    gpu_set_blendmode(bm_add);
    
    // Calcula pulso opcional pra animação cartunesca
    var _pulse_scale = 1;
    if (_pulse) {
        _pulse_scale = 1 + sin(current_time * 0.005) * 0.2;  // Pulso suave, como Sdash animado!
    }
    
    // Desenha camadas de glow borrado (multiplas draws pra efeito suave)
    for (var i = 1; i <= 3; i++) {  // 3 camadas pra glow gradual
        var _alpha = _intensity / (i * 2);  // Alpha diminui pras bordas
        var _scale = _pulse_scale * (1 + (i * _radius / 32));  // Expande o raio
        draw_sprite_ext(_sprite, _subimg, _x, _y, _xscale * _scale, _yscale * _scale, _rot, _color, _alpha);
    }
    
    // Reseta blend mode e desenha o sprite original por cima
    gpu_set_blendmode(bm_normal);
    draw_sprite_ext(_sprite, _subimg, _x, _y, _xscale, _yscale, _rot, c_white, 1);
}
	
function mover_suavemente(_x_alvo, _y_alvo, _velocidade) {
    x = lerp(x, _x_alvo, _velocidade);
    y = lerp(y, _y_alvo, _velocidade);
    if (point_distance(x, y, _x_alvo, _y_alvo) < 1) {
        x = _x_alvo;
        y = _y_alvo;
    }
}
	
function piscar_objeto(_duracao, _intervalo) {
    if (!variable_instance_exists(id, "piscar_tempo")) piscar_tempo = 0;
    if (!variable_instance_exists(id, "piscar_visivel")) piscar_visivel = true;
    
    piscar_tempo = (piscar_tempo + 1) mod _intervalo;
    if (piscar_tempo == 0) piscar_visivel = !piscar_visivel;
    visible = piscar_visivel && (piscar_tempo < _duracao);
    
    if (piscar_tempo >= _duracao) piscar_tempo = 0;
}		
	
function rotacionar_gradual(_angulo_alvo, _duracao) {
    if (!variable_instance_exists(id, "angulo_inicial")) angulo_inicial = image_angle;
    if (!variable_instance_exists(id, "tempo_transicao")) tempo_transicao = 0;
    
    tempo_transicao = min(tempo_transicao + 1, _duracao);
    var _fator = tempo_transicao / _duracao;
    image_angle = lerp(angulo_inicial, _angulo_alvo, _fator);
    
    if (tempo_transicao == _duracao) {
        angulo_inicial = _angulo_alvo;
        tempo_transicao = 0;
    }
}	
	
function seguir_alvo(_obj_alvo, _distancia, _velocidade) {
    if (instance_exists(_obj_alvo)) {
        var _dir = point_direction(x, y, _obj_alvo.x, _obj_alvo.y);
        var _dist = point_distance(x, y, _obj_alvo.x, _obj_alvo.y);
        if (_dist > _distancia) {
            var _move_x = lengthdir_x(_velocidade, _dir);
            var _move_y = lengthdir_y(_velocidade, _dir);
            x += _move_x;
            y += _move_y;
        }
    }
}	
	
function ini_boing(_xscale = 1, _yscale = 1){
		xscale_original = _xscale;
		yscale_original = _yscale;
		xscale = xscale_original;
		yscale = yscale_original;
}

function aplica_boing(_xscale = 2, _yscale = 2){
		xscale = _xscale
		yscale = _yscale
}

function efeito_boing(){
	xscale = lerp(xscale, xscale_original, .1);
	yscale = lerp(yscale, yscale_original, .1);
}
	
function desenha_boing(){
	draw_sprite_ext(sprite_index, image_index, x, y, xscale, yscale, image_angle, image_blend, image_alpha);	
}
	
function efeito_brilho(_cor = c_white, _tempo = 30) constructor{
	//variaveis do constructor
	cor = _cor;
	valor = 1 / _tempo;
	alpha = 1;
	brilho = false;
	
	//criando metodos
	static inicia_brilho = function(){
		brilho = true;
		alpha = 1;
	}
	
	static brilhando = function(){
		if(brilho){
			if(alpha > 0){
				alpha -= valor;	
			}else{
				brilho = false;	
			}
		}
	}
	
	static desenha_brilho = function(){
		if(brilho){
			var _alpha = alpha;
			var _cor = cor;
			with(other){
				shader_set(sd_brilho);
				draw_sprite_ext(sprite_index, image_index, x, y, xscale, yscale, image_angle, _cor, _alpha)
				shader_reset();
			}
		}
	}
}
	
function desenha_sombra(_escala = .5){
	var _y = y - sprite_yoffset + sprite_height;
	draw_sprite_ext(spr_sombra_item, 0, x - 6, _y, _escala, _escala, 0, c_white, .5);
}
	

#endregion

#region Variáveis globais 

#region Geral e Configurações

global.save = 0;

global.tem_magia = array_create(5, false);

//global.tem_magia[0] = true;
//global.tem_magia[1] = true;
//global.tem_magia[2] = true;
//global.tem_magia[3] = true;
//global.tem_magia[4] = true;

global.magia_selecionada = 0;


global.seletor_visivel = true

global.tutorial = false;

//serve para que o sdash nao possa se movimentar enquanto o inventario estiver aberto e tambem para o sistema de pause em geral
global.pause = false;

//idioma padrão
global.lingua = "pt-br";

global.pause_por_inventario = false

//controla se o sdash pode construir
global.modo_construcao = false

//se esta em um dialogo:
global.dialogo_acontecendo = false;

//checa quantos inimigos tu matou até entao
global.inimigos_mortos = 0;

//checa o numero de cavalos alimentados
global.cabalos_alimentados = 0;

//iten e consumiveis e inimigos
global.orbs = 0;

//total de minions na batalha contra o andrius mortos
global.minions_mortos = 0;

//moedas
global.moedas = 0;

#endregion

#region  Moralidade
global.maldade = 0;
global.bondade = 0;
global.honestidade = 0;
global.egoismo = 0;

// Reputação
global.fama = 0;
global.temido = 0;
global.respeito = 0;

// Relacionamentos
global.caridade = 0;
global.lealdade = 0;
global.rancor = 0;

// Impacto no mundo
global.caos = 0;
global.ordem = 0;
global.riqueza = 0;

// Personagem
global.arrogancia = 0;
global.empatia = 0;
global.ambicao = 0;
#endregion

#endregion
