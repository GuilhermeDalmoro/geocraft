function scr_boss_escolher_ataque(){
	if alarm[0] <= 0{
		var _ataque = choose(scr_boss_ataque1,scr_boss_ataque2,scr_boss_ataque3,scr_boss_ataque4); //o boss vai escolher qual ataque lançar
		estado = _ataque;
		alarm[0] = 100;
	}
}

function scr_boss_ataque1(){//bonequinho do geometry dash
	
	   var _dir = 0; // direção do ataque
    var _repeticao = irandom_range(2,6);
    repeat(_repeticao) { // cria diferentes quantidades de miniosn em diferentes direções
		obj_boss_andrius.image_index = spr_andrius_estado_minions;
        var _inst = instance_create_layer(x, y, "Instances", obj_minion_andrius_1);
        
        _inst.speed				     = 1; // velocidade do projétil
        _inst.direction		     = _dir; // direção do projétil
        _inst.image_xscale     = 0.5; // Reduz a escala no eixo X (50% do tamanho original)
        _inst.image_yscale     = 0.5; // Reduz a escala no eixo Y (50% do tamanho original)

        _dir += 45; // faz com que o projétil vá nas 4 direções
    }
    estado = scr_boss_escolher_ataque;
	obj_boss_andrius.image_index = spr_andrius_boss
	
		var _dir1 = 0; //direção do ataque
   		
	repeat(12){  // cria 12 vezes o projetil do andrin
			var _inst = instance_create_layer(x, y, "Instances", obj_boss_andrius_projetil);
			_inst.speed = 4 //velocidade do projetil
			_inst.direction = _dir; //direção do projetil
			_dir1 +=  45; //faz com que o projetil va nas 4 direções 
	}
	estado = scr_boss_escolher_ataque;
}

function scr_boss_ataque2(){//ataque dos minions felipitos
	//obj_boss_andrius.image_index = spr_andrius_estado_minions;
    var _dir = 0; // direção do ataque
    var _repeticao = irandom_range(2,6);
    repeat(_repeticao) { // cria diferentes quantidades de miniosn em diferentes direções
		obj_boss_andrius.image_index = spr_andrius_estado_minions;
        var _inst = instance_create_layer(x, y, "Instances", obj_minion_andrius_1);
        
        _inst.speed				     = 1; // velocidade do projétil
        _inst.direction		     = _dir; // direção do projétil
        _inst.image_xscale     = 0.5; // Reduz a escala no eixo X (50% do tamanho original)
        _inst.image_yscale     = 0.5; // Reduz a escala no eixo Y (50% do tamanho original)

        _dir += 45; // faz com que o projétil vá nas 4 direções
    }
    estado = scr_boss_escolher_ataque;
	obj_boss_andrius.image_index = spr_andrius_boss
}

function scr_boss_ataque3(){//bomba fragmentada
	
	   var _dir = 0; // direção do ataque
    var _repeticao = irandom_range(2,6);
    repeat(_repeticao) { // cria diferentes quantidades de miniosn em diferentes direções
		obj_boss_andrius.image_index = spr_andrius_estado_minions;
        var _inst = instance_create_layer(x, y, "Instances", obj_minion_andrius_1);
        
        _inst.speed				     = 1; // velocidade do projétil
        _inst.direction		     = _dir; // direção do projétil
        _inst.image_xscale     = 0.5; // Reduz a escala no eixo X (50% do tamanho original)
        _inst.image_yscale     = 0.5; // Reduz a escala no eixo Y (50% do tamanho original)

        _dir += 45; // faz com que o projétil vá nas 4 direções
    }
    estado = scr_boss_escolher_ataque;
	obj_boss_andrius.image_index = spr_andrius_boss
	
	repeat(4){
		var _xx = irandom_range(x-150, x+150);
		var _yy = irandom_range(y-150, y+150);
		
		instance_create_layer(_xx, _yy, "Instances", obj_boss_andrius_ataque_2);
	}
	estado = scr_boss_escolher_ataque;
}

function scr_boss_ataque4(){//ataque numerico
	   var _dir = 0; // direção do ataque
    var _repeticao = irandom_range(2,6);
    repeat(_repeticao) { // cria diferentes quantidades de miniosn em diferentes direções
		obj_boss_andrius.image_index = spr_andrius_estado_minions;
        var _inst = instance_create_layer(x, y, "Instances", obj_minion_andrius_1);
        
        _inst.speed				     = 1; // velocidade do projétil
        _inst.direction		     = _dir; // direção do projétil
        _inst.image_xscale     = 0.5; // Reduz a escala no eixo X (50% do tamanho original)
        _inst.image_yscale     = 0.5; // Reduz a escala no eixo Y (50% do tamanho original)

        _dir += 45; // faz com que o projétil vá nas 4 direções
    }
    estado = scr_boss_escolher_ataque;
	obj_boss_andrius.image_index = spr_andrius_boss
	
	var _dir1 = 0;
	repeat(8){
		var _inst = instance_create_layer(x, y, "Instances", obj_numeros);
				_inst.sprite_index = choose(spr_numeros);
				_inst.speed = 1 //velocidade do projetil
				_inst.direction = _dir1; //direção do projetil
				_dir +=  45; //faz com que o projetil va nas 4 direções 
				_inst.image_xscale = 0.5; // Reduz a escala no eixo X (50% do tamanho original)
                _inst.image_yscale = 0.5; // Reduz a escala no eixo Y (50% do tamanho original)
			//_inst.image_alpha = 0.5; //alfa da imagem
				_inst.image_blend = choose(c_purple,c_green,c_red,c_blue,c_orange); ///cores aos numbers
		}
		estado = scr_boss_escolher_ataque;
	}