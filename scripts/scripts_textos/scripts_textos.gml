#region Guarda todos os dialogos do jogo
function scr_textos(){ //esse é o script que ira guardar todos os dialogos simples do jogo
	
    switch npc_nome{ //dentro do switch case vai estar qual texto de qual personagem e o texto que ele vai exibir
		 
        case "igreja":
            ds_grid_add_text("Deseja rezar um pai nosso e uma Ave-Maria?", spr_ret_reia, 0, "Santuario")
            add_op("Sim", "rezar")
            add_op("Não", "nrezar")
        break;
    
        case "rezar":
            ds_grid_add_text("Reza concluida :D", spr_ret_sdash_contente, 1, "Sdash")
        break;    
        
        case "nrezar":
            ds_grid_add_text("Vou sair daqui", spr_ret_sdash_normal, 1, "Sdash")
        break;
        
        case "fonte_agua":
          ds_grid_add_text("acho que seria legal eu fazer algum desejo...", spr_ret_sdash_emotivo, 0, "Sdash")  
          ds_grid_add_text("Oque você deseja? :D", spr_fonte_agua, 1, "Fonte de agua"); 
          ds_grid_add_text(" [cor=azul] CARALHO QUE PORRA É ESSA  [/cor] [semefeito]", spr_ret_sdash_levando_vantagi, 0, "Sdash");
        break;   
    
        
		  case "teste_inicio":
            ds_grid_add_text("[tremor]Eu sou o Teste, o monstro cúbico![/tremor]", spr_portrait_teste, 0, "Teste");
            ds_grid_add_text("Acha que pode com esse chapéu de cowboy?", spr_portrait_teste, 0, "Teste");
            add_op("Provocar", "teste_provocar");
            add_op("Checar", "teste_checar");
            break;
        
        case "teste_provocar":
            ds_grid_add_text("Haha, seu chapéu é ridículo!", spr_ret_sdash_normal, 1, "Sdash");
            global.inimigo[0].vida_max -= 10;
            break;
        
        case "teste_checar":
            ds_grid_add_text("descrição", spr_ret_sdash_normal, 1, "Sdash");
            break;
        
        case "ataque_onda_basica_intro":
            ds_grid_add_text("[wave]Preparado pra onda cúbica?[/wave]", spr_portrait_teste, 0, "Teste");
            break;
        
        case "ataque_onda_basica":
            ds_grid_add_text("[wave]Toma essa, cowboy![/wave]", spr_portrait_teste, 0, "Teste");
            break;
        
        case "ataque_onda_basica_fim":
            ds_grid_add_text("Haha, sobreviveu dessa vez!", spr_portrait_teste, 0, "Teste");
            break;
        
        case "ataque_geometry_dash_intro":
            ds_grid_add_text("[shake]Hora de pular como em Geometry Dash![/shake]", spr_portrait_teste, 0, "Teste");
            break;
        
        case "ataque_geometry_dash":
            ds_grid_add_text("[shake]Desvia desses cubos, Sdash![/shake]", spr_portrait_teste, 0, "Teste");
            break;
        
        case "ataque_geometry_dash_fim":
            ds_grid_add_text("Não tá fácil, né?", spr_portrait_teste, 0, "Teste");
            break;
        
        case "ataque_hotline_miami_intro":
            ds_grid_add_text("[color=red]Bem-vindo ao caos, cowboy![/color]", spr_portrait_teste, 0, "Teste");
            break;
        
        case "ataque_hotline_miami":
            ds_grid_add_text("[color=red]Cuidado com a multidão![/color]", spr_portrait_teste, 0, "Teste");
            break;
        
        case "ataque_hotline_miami_fim":
            ds_grid_add_text("Você é rápido, hein?", spr_portrait_teste, 0, "Teste");
            break;
        
        case "sdash_atacar":
            ds_grid_add_text("[shake]Toma essa, monstro![/shake]", spr_ret_sdash_normal, 1, "Sdash");
            break;
        
        case "teste_nao_poupar":
            ds_grid_add_text("Não vou te poupar tão fácil!", spr_portrait_teste, 0, "Teste");
            break;
		
		
		
		
		
		
		
		
		
		
		
		case "PC_Fim":
		ds_grid_add_text("Caralho, [pulsar][cor=verde]hackeei " + string(global.pc_score) + " dejetos[/cor][/pulsar][semefeito]!", spr_ret_sdash_normal, 0, "Sdash");
		break; 
				 
		 case "Primeiro Texto":
        ds_grid_add_text("Este [pulsar] [cor=roxo] dejeto [/cor] [/pulsar] [semefeito] [flutuar] canta [/flutuar] [semefeito] o [onda] [cor=azul] hino [/cor] [/onda] [semefeito] da [tremor] invasão [/tremor] [semefeito]!", spr_ret_reia, 1, "Placa");
        ds_grid_add_text("Meu Deus do Céu [abalo] [cor=vermelho] OQUE FOI QUE EU FIZ [/cor] [/abalo] [semefeito]", spr_ret_sdash_paralisado, 0, "Sdash");
        break;		
		
		case "janela":
		ds_grid_add_text("Quando a pedra quebrou, teu nome ecoou nas ruínas.", spr_ret_sdash_emotivo, 1, "Sdash");
		ds_grid_add_text("Ao olhar pra janela, eu sinto propósito.", spr_ret_sdash_emotivo, 1, "Sdash");
		break;
		
		case "suba a escada":
		ds_grid_add_text("Suba a escada :) ", spr_escada, 0, "ESCADA")
		break;
		
		
		case "placa cobre":
		ds_grid_add_text("[semefeito] Esse é um mural dos [/semefeito] [cor=amarelo] [onda]  presidentes [/cor] [/onda] [semefeito] anteriores de cubic land [/semefeito]", spr_ret_reia,0, "Placa de Cobre")
		ds_grid_add_text("A prefeitura esconde um segredo, deixe de ser baiano e vai procurar", spr_ret_reia,0, "Placa de Cobre")
		ds_grid_add_text("....", spr_ret_sdash_paralisado,1, "Sdash")
		ds_grid_add_text("Sim, provavelmente quem escreveu essa placa é xenofóbico", spr_ret_reia,0, "Placa de Cobre")
		ds_grid_add_text("Sim, so agora eu entendi cubic land tem um humor meio [flutuar] [cor=roxo] duvidoso", spr_ret_sdash_levando_vantagi,1, "Sdash")
		break; 
		
		case "Segundo Texto":
		ds_grid_add_text("Nossa mano, oque tu ta fazendo aqui ? ..", spr_ret_sdash_normal, 0, "Sdash");
		ds_grid_add_text("A sla tava so dando uma volta pelas redondesas aqui...", spr_ret_king_arts_normal, 1, "King of Art's")
		ds_grid_add_text("Pera... \n [zoom]MAS QUE PORRA É AQUELA???? [/zoom] [semefeito]Sdash, você não tocou naquele [/semefeito] [cor=roxo] dejeto [semefeito] né? [/semefeito]", spr_ret_king_arts_normal, 1, "King of Art's")//obj_king_art.meu_nome)
		ds_grid_add_text("Então.... eu comi um pouco, e to me sentindo... diferente [pulsar] [cor=vermelho] eu acho..", spr_ret_sdash_normal, 0, "Sdash");
		ds_grid_add_text("Sdash... SEU IMBECIL ME ESPERE NO ESTABULO, EU IREI COMUNICAR O [cor=amarelo] ALMUDEAO [/cor] [semefeito] COM VOCÊ [/semefeito]", spr_ret_king_arts_bravo, 0, "King of Art's")
        gc_state_area_set(1, true);
		break;
		
		
        case "missao1_king_arts":
        ds_grid_add_text("Sdash vamos ir até o almudeão.", spr_ret_king_arts_normal, 1, "King of Art's")    
        ds_grid_add_text("Logo depois vamos ir até o centro da cidade.", spr_ret_king_arts_normal, 1, "King of Art's")  
        
    	break;
    
        case "missao1_king_arts2":
        ds_grid_add_text("Me encontre perto do estabulo", spr_ret_king_arts_normal, 1, "King of Art's")    
        resetar_camera();
    	break;
    
    
        case "missao1_king_arts1":
        ds_grid_add_text("SDASH, PUTA QUE O PARIU, ALGUNS GMDS APARECERAM", spr_ret_king_arts_bravo, 1, "King of Art's")    
        ds_grid_add_text("APERTE O BOTÃO ESQUERDO DO MOUSE PARA ATACAR", spr_ret_king_arts_bravo, 1, "King of Art's" )
            
        repeat (9) {
           instance_create_layer(784, 167, "Instances", obj_gmd);
         }
                
        var _revolver = instance_create_layer(0, 0, "Instances", obj_revolver)
        _revolver.image_xscale = 2;
        _revolver.image_yscale = 2;
            
    	break;
            
		case "Texto treino":
		ds_grid_add_text("Bom sdash, vamos só.... treinar um pouquinho", spr_ret_king_arts_normal,1,"King of Art's")
		ds_grid_add_text("Certo mano!! oque eu tenho que fazer?", spr_ret_sdash_normal,0,"Sdash")
		ds_grid_add_text("Hum... - de- derro-... DERROTA ESSES FELA DA PUTA SDASH!, essa é sua primeira missão", spr_ret_king_arts_normal,1,"King of Art's")
		ds_grid_add_text("Aceita a primeira misao?", spr_ret_king_arts_normal, 1, "King of Art's")
		
		add_op("Então... eu aceito", "rsp 1")
		add_op("Então mano, acho melhor não", "rsp 2")
		break;
		
		case"rsp 1":
		gc_quest_start("treino_gmd");
    
		ds_grid_add_text("Vamos nessa então", spr_ret_king_arts_bravo, 1, "King of Art's")
		ds_grid_add_text("Porém antes receba uma magia", spr_ret_king_arts_bravo, 1, "King of Art's");
		ds_grid_add_text("E receba este arco", spr_ret_king_arts_bravo, 1, "King of Art's");
		ds_grid_add_text("Para usar a magia utilize a tecla Z e para utilizar o [cor=amarelo] arco [/cor] equipe no inventario e utilize o botao esquerdo", spr_ret_king_arts_bravo, 1, "King of Art's");
		var _inst = instance_create_layer(x + 8, y - 9, "Instances", obj_item)
		_inst.item = global.itens[| ITENS.arco]
		gc_state_magic_set(0, true);
		ds_grid_add_text("[cor=amarelo] [flutuar] Para acessar o menu de missões aperte M", spr_ret_reia, 0, "Aviso")
		gc_state_reputation_add("lealdade", -3);
		break;
		case"rsp 2":
		ds_grid_add_text("Ta bom então né", spr_ret_king_arts_bravo, 0, "King of Art's")
		gc_state_reputation_add("lealdade", -1);
		break;
		
		case "Texto treino pag 2":
		ds_grid_add_text("MUITO BEM SDASH, voce conseguiiiiu",spr_ret_king_arts_orgulhoso,1,"King of Art's");
		gc_state_magic_set(1, true);
        gc_quest_complete("treino_gmd");
        gc_quest_start("alimentar_cavalos");
		ds_grid_add_text("Agora que voce treinou o bastante sdash, me espere no estabulo que \n nos iremos alimentar os cavalos do almudeão:",spr_ret_king_arts_orgulhoso,1,"King of Art's");
		break;
		
		case "Cavalos texto":
		ds_grid_add_text("IRRHOOOO, IRHOOOO", spr_ret_cavalos,1, "Cabalo")
		ds_grid_add_text("Porra velho fala direito", spr_ret_sdash_normal,0,"Sdash")
		ds_grid_add_text("me da comida", spr_ret_cavalos,1, "Cabalo")
		ds_grid_add_text("Aperte control para alimentalos",spr_ret_reia,1,"Placa")
		break;
		
				
		case"Cavalos texto easter egg":
		ds_grid_add_text("esses dias eu vi um homem....\n e ele fez algumas coisas estranhas comigo... e tinha 2050 exercitos com ele ....", spr_ret_cavalos_safado,1,"Cavalifero")
		ds_grid_add_text("Qual .... qual era o nome dele?", spr_ret_sdash_normal,0,"Sdash")
		ds_grid_add_text("Começava com C... eu nao sei.., me desculpe sdash eu realmente nao sei :((", spr_ret_cavalos,1,"Cavalifero")
		break;
		
		case "oloco":
		ds_grid_add_text("Complete a missao para prosseguir", spr_ret_reia, 1, "teste");
		break;
	
		case "Missao Cavalos":
	    ds_grid_add_text("Olá sdash, eu preciso te dizer uma coisa...", spr_almudeao_frente, 1, "Almudeao");
	    ds_grid_add_text("O - oque... ;--;", spr_ret_sdash_normal, 0, "Sdash");
	    ds_grid_add_text("Não é algo muito grave né?", spr_ret_sdash_emotivo, 0, "Sdash");
	    ds_grid_add_text("Não,  é so que.. no caminho eu ouvi [flutuar] um barulho [/flutuar]...", spr_almudeao_frente, 1, "Almudeao");
	    ds_grid_add_text("Vamos indo ate o centro da cidade, pegue um cavalo e vamos nessa", spr_almudeao_frente, 1, "Almudeao");
	    add_op("Ok to indo", "resp1cav");
		break;
						
			case "resp1cav":
		    ds_grid_add_text("otimo", spr_almudeao_frente, 1, "Almudeao");
			break;
    
	
	case "Almudeao_Bloqueado":
    ds_grid_add_text("Ei, Sdash! Antes de ajudar os cavalos, derrote aqueles inimigos geométricos na Room 2, vai! [fim]", spr_ret_sdash_normal, 0, "Sdash");
    break;

    
        case "andrius_entrada":
          ds_grid_add_text("Nós vamos até aonde mesmo almudeão?", spr_ret_sdash_preocupado, 0, "Sdash")  
          ds_grid_add_text("Nós vamos até..", spr_ret_almudeao, 1, "Almudeao"); 
          ds_grid_add_text(" [cor=azul] CARALHO QUE PORRA É ESSA  [/cor] [semefeito]", spr_ret_sdash_irritado, 0, "Sdash");
          ds_grid_add_text("SDASH SE PREPARA CARALHO", spr_ret_almudeao, 1, "Almudeao")  
        break;    
		 
		
		case"Sir gritado":
		ds_grid_add_text("OLA SDASH, VOCÊ SABIA QUE A MAIOR AVENTURA É... UMA AVE QUE VOA LONGE?! ENTENDEU? AVE-N-TURA! HAHAHA !", spr_sir_gritado,1,"Sir gritorideo")
		ds_grid_add_text("voce é muito leal nao é mesmox!", spr_sir_gritado,1,"Sir gritorideo")
		ds_grid_add_text("Olá? ao inves de voce ficar gritando e contando piadas ruins voce poderia me dar uma informação util?",spr_ret_sdash_levando_vantagi,0,"Sdash")
		ds_grid_add_text("EU NAO TENHO NENHUMA INFORMAÇÃO UTIL PARA VOCE MAS SE QUISER VOCE PODE ENTRAR NA MINHA CASA", spr_sir_gritado,1,"Sir gritorideo")
		break;
		
		case"Professor pei 1":
		ds_grid_add_text("Olá meu nome é senhor paytowin", spr_ret_senhor_pei,1,"senhor paytowin");
		ds_grid_add_text("Você gostaria de comprar alguns mapas ou poções?", spr_ret_senhor_pei,1,"senhor paytowin");
		
		add_op("sim", "resposta sim")
		add_op("não", "resposta nao")
		break;
		
			case"resposta sim":
			ds_grid_add_text("Você pode entrar na minha loja entao :)", spr_ret_senhor_pei,1,"senhor paytowin");
			break;
			
			case"resposta nao":
			ds_grid_add_text("Tudo bem então", spr_ret_senhor_pei,1,"senhor paytowin");
			break;
		
		case"dona petunia":
		ds_grid_add_text("Olá pequeno Sdash, onde esta o almudeao?", spr_ret_dona_petunia_normal,1,"Dona Petunia");
		ds_grid_add_text("Olá Dona Petunia como vai a senhora? como esta o jardim?.",spr_ret_sdash_emotivo,0,"Sdash")
		ds_grid_add_text("A sdash eu vou bem e hoje eu resolvi plantar Tomates e Batatas, você quer um pouco?", spr_ret_dona_petunia_normal,1,"Dona Petunia");
			add_op("Simmm, mas oq eles fazem?","nome faz1")
			add_op("Não quero mas obrigado","nome faz2")
			break;
		
			case"nome faz1":
			ds_grid_add_text("Comer o tomate recupera 8 de vida, ja a batata te da mais 4 de gordura corporal!",spr_ret_dona_petunia_feliz,1,"Dona petunia")
			ds_grid_add_text("toma!",spr_ret_dona_petunia_feliz,1,"Dona petunia") 
            var _inst_trigo = instance_create_layer(x + 8, y - 9, "Instances", obj_item) 
            _inst_trigo.item = global.itens[| ITENS.trigo]
			break;
			case"nome faz2":
			ds_grid_add_text("Tudo bem então!",spr_ret_dona_petunia_feliz,1,"Dona petunia")
			break;
			
		case"quadro1":
		ds_grid_add_text("Isto é somente um quadro", spr_quadro,1,"Quadro");
		break;
		
		case"espelho1":
		ds_grid_add_text("Esse sou eu... Sdash", spr_espelho,1,"Espelho");
		break;
		
		case "easter egg daniel fraga 1":
		ds_grid_add_text("Sonegar é preciso", spr_ret_reia,1,"Daniel fraga")
		break;
		
		
		case "Missao_Concluida":
	    ds_grid_add_text("Caralho, [zoom][cor=amarelo] eu me sinto PODEROSO [/cor][/zoom][semefeito]!!", spr_ret_sdash_normal, 0, "Sdash");
		global.salva_jogo();
	    break;
		
		case "Missao2_Concluida":
	    ds_grid_add_text("Uhul mais uma tarefa completa pro meu mestre ^_^", spr_ret_sdash_normal, 0, "Sdash");
	    break;
		
		case "boas_vindas":
	    ds_grid_add_text("Olá, seja bem-vindo ao [cor=amarelo] [pulsar] Geocraft", spr_ret_criador, 0, "Sdash");
	    ds_grid_add_text("Para andar você pode utilizar \n [cor=amarelo] WASD", spr_ret_criador, 0, "Sdash");
		ds_grid_add_text("Para atacar voce pode utilizar o [cor=vermelho] botão esquerdo do mouse", spr_ret_criador, 0, "Sdash");
		ds_grid_add_text("Para dar um dash voce pode utilizar o [cor=roxo] botão direito do mouse", spr_ret_criador, 0, "Sdash");
		ds_grid_add_text("Para interagir você pode [cor=amarelo] pressionar a tecla F", spr_ret_criador, 0, "Sdash");
		ds_grid_add_text("Para abrir seu inventario você pode [cor=amarelo] pressionar a tecla E", spr_ret_criador, 0, "Sdash");
		ds_grid_add_text("Não se preocupe, o jogo ira te guiar quando precisar ", spr_ret_criador, 0, "Sdash");
	    ds_grid_add_text("[cor=vermelho] Porém cuidado com quem você fala \n Ele é poderoso", spr_ret_criador_puto, 0, "Sdash");
		global.tutorial = true;
        if (variable_global_exists("game_state") && is_struct(global.game_state)) {
            global.game_state.campaign.unlocks.tutorial = true;
        }
	    break;
		
		  case "Salva jogo":
          ds_grid_add_text("[onda][cor=amarelo] O caos criou reis. Você nasceu no estilhaço.", spr_ret_sdash_normal, 0, "Sdash");
          ds_grid_add_text("[onda][cor=amarelo] Jogo salvo", spr_ret_sdash_normal, 0, "Sdash");
		  global.salva_jogo();
          break;
			}
}
#endregion

#region Funções de texto
function ds_grid_add_row(){ //essa função serve para adicionar mais uma linha na ds grid
	
	var _grid = argument[0];
	ds_grid_resize(_grid,ds_grid_width(_grid), ds_grid_height(_grid) + 1);
	return(ds_grid_height(_grid) -1);
}

function ds_grid_add_text(){ //essa função serve pra adicionar o texto do dialogo
	///@arg texto
	///@arg retrato
	///@arg lado
	
	var _grid = texto_grid;
	var _y = ds_grid_add_row(_grid);
	
	_grid[# 0, _y] = argument[0]; //Texto
	_grid[# 1, _y] = argument[1]; //Retrato
	_grid[# 2, _y] = argument[2]; //Lado
	_grid[# 3, _y] = argument[3]; //Nome 
 //_grid[# 4, _y] = argument[4]; //terminou
 //_grid[# 4, _y] = argument[4]; //Som
 
}
	
function add_op(_texto_op, _resposta){ //essa função serve para adicionar uma opção
	opcao[opcao_numero] = _texto_op;
	opcao_resposta[opcao_numero] = _resposta;
	
	opcao_numero++;
}
	
function draw_text_effect(_x, _y, _texto, _sep, _width, _palavras, _efeitos) {
    var _current_x = _x;
    var _current_y = _y;
    var _char_count = 0;
    
    for (var i = 0; i < array_length(_palavras); i++) {
        var _palavra = _palavras[i];
        var _palavra_len = string_length(_palavra);
        var _palavra_width = string_width(_palavra);
        
        // Verifica se a palavra cabe na linha
        if (_current_x + _palavra_width > _x + _width) {
            _current_y += _sep;
            _current_x = _x;
        }
        
        // Aplica efeito por palavra
        var _effect_x = _current_x;
        var _effect_y = _current_y;
        var _effect_color = c_white;
        var _effect_scale = 1;
        
        if (i < array_length(_efeitos)) {
            var _efeito = _efeitos[i];
            if (_efeito.tipo == "tremor") {
                _effect_x += random_range(-1.5, 2);
                _effect_y += random_range(-1.5, 2);
            }
            if (_efeito.tipo == "bounce") {
                _effect_y += sin(current_time * 0.005 + i) * 4;
            }
           if (_efeito.tipo == "pulsar") {
                _effect_scale = 1 + sin(current_time * 0.005 + i) * 0.15; 
            }
            if (_efeito.tipo == "zoom") {
                _effect_scale = 1 + sin(current_time * 0.01 + i) * 0.2; 
            }
            if (_efeito.tipo == "flutuar") {
                _effect_y += sin(current_time * 0.003 + i) * 1; // Flutua suave
            }
            if (_efeito.tipo == "onda" || _efeito.tipo == "abalo") {
                // Aplicado por caractere no loop abaixo
            }
            _effect_color = _efeito.cor;
        }
        
        // Desenha caractere por caractere
        for (var j = 1; j <= _palavra_len; j++) {
            _char_count++;
            if (_char_count > string_length(_texto)) break; // Respeita caractere atual
            
            var _char = string_char_at(_palavra, j);
            var _char_width = string_width(_char);
            
            // Aplica efeitos por caractere
            var _char_x = _effect_x;
            var _char_y = _effect_y;
            if (i < array_length(_efeitos)) {
                if (_efeitos[i].tipo == "onda") {
                    _char_y += sin(current_time * 0.003 + (i * 0.5 + j * 0.2)) * 4; // Onda por letra
                }
                if (_efeitos[i].tipo == "abalo") {
                    _char_x += random_range(-1.8, 2.5); // Tremor individual por letra
                    _char_y += random_range(-1.8, 2.5);
                }
            }
            
            draw_set_color(_effect_color);
            draw_text_transformed(_char_x, _char_y, _char, _effect_scale, _effect_scale, 0);
            
            _effect_x += _char_width * _effect_scale;
        }
        
        _current_x += _palavra_width;
        if (_char_count > string_length(_texto)) break;
    }
    
    draw_set_color(c_white);
}
	
#endregion