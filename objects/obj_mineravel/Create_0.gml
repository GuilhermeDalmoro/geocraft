ini_boing();

vida_max = 2
vida = vida_max

meu_brilho = new efeito_brilho(c_white, 60) 

z = 0;
velz = 0;
grav = .25;

perde_vida = function(_dano = 1){
	vida -= _dano
	if(vida <= 0 ){	
		dropa_item();	
		instance_create_depth(x, y, depth -10, obj_brilho)
	}
}



dropa_item = function(){
	var _ind = 0;
	var _chance = random(100)
	
	switch(dropavel){
		case "pedra":
		 _ind = 0; 
		break;
		
		case "madeira":
		_ind = 1;
		break;
		
		case "cerca":
		_ind = 2;
		break;
		
		case "flor":
		_ind = 3;
		break;
		
		case "bloco_pedra":
		_ind = 4;
		break;
		
		case "blmadeira":
		_ind = 5;
		break;
		
		case "bloco_terra":
		_ind = 6;
		break;
		
		}
		
		//criando o dropavel
		var _repete = 1;
		
		if (_chance >= 99){
			_repete = 12
		}else if (_chance > 60 ){
			_repete = 6
		}else if (_chance > 50 ){
			_repete = 4
		}else if (_chance > 30 ){
			_repete = 2
		}
		
		
		repeat(_repete){
			var _x = x + random_range(-10, 10);
			var _y = y+ random_range(-10, 10)
			var _drop = instance_create_depth(_x, _y, depth, obj_drop);
			_drop.image_index =  _ind;
			_drop.meu_id = ITENS.pedra + _ind;
		
			instance_destroy();
		}
}