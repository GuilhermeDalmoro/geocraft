/// @description Insert description here
if(global.pause == false){
	script_execute(estado);

	depth = -y;

	if vida <= 0{
		instance_destroy();
		global.inimigos_mortos += 1;
		drop_moedas(x  ,y , 2, 4)
		//drop_item(obj_farinacio_trigo,3)
	}
}