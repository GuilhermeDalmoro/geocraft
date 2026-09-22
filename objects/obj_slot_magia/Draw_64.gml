if (global.pause || global.dialogo_acontecendo) exit;

if instance_exists(obj_sdash){
	if (!obj_sdash.active) exit;
		for (var i = 0; i < num_slots; i++) {
			    if (global.tem_magia[i]) {
			        var angulo = i * (360 / num_slots);
			        var _x = centro_x + lengthdir_x(raio, angulo);
			        var _y = centro_y + lengthdir_y(raio, angulo);

			        // desenhar célula
			        draw_sprite_ext(spr_slot, 0, _x - 420, _y + 310, escala[i] * 1.5, escala[i] * 1.5, 0, c_white, 1);

			        // ícone da magia dentro
			        draw_sprite_ext(spr_icones_magia, i, _x - 420, _y + 310, 1.5, 1.5 , 0, c_white, 1);
			    }
		}
}