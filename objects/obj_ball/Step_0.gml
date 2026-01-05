if (global.pause == false){
	script_execute(estado);

	depth = -y;

	if vida <= 0 {
			instance_destroy();
			drop_moedas(x ,y , 10, 20)
			global.inimigos_mortos += 1;
	}
}