shader_set(sd_saturacao);
shader_set_uniform_f(shader_get_uniform(sd_saturacao, "u_saturation"), 2); // 1.8 = saturado

draw_sprite_ext(spr_sombra_item, 0, x - 14, y + 5, 1,1, 0, c_white, .5);

draw_self();

if alarm[3] > 0{
 if image_alpha >= 1{
	 dano_alfa = -0.05;
 }else if image_alpha <= 0{
	 dano_alfa = 0.05;
 }
 
 image_alpha += dano_alfa;
}else{
	image_alpha = 1;
}

if (ray_fx_timer > 0) {
    draw_set_alpha(1);
    draw_set_color(c_yellow);
    var seg = 5; // quantos segmentos vai ter o raio
    var px = ray_fx_x1;
    var py = ray_fx_y1;
    for (var i = 1; i <= seg; i++) {
        var t = i / seg;
        var nx = lerp(ray_fx_x1, ray_fx_x2, t);
        var ny = lerp(ray_fx_y1, ray_fx_y2, t);
        // desviozinho pro raio ficar “elétrico”
        nx += irandom_range(-4,4);
        ny += irandom_range(-4,4);
        draw_line(px, py, nx, ny);
		draw_line(ray_fx_x1, ray_fx_y1, ray_fx_x2, ray_fx_y2);
		draw_line(ray_fx_x1+1, ray_fx_y1, ray_fx_x2+1, ray_fx_y2);
		draw_line(ray_fx_x1-1, ray_fx_y1, ray_fx_x2-1, ray_fx_y2);
		draw_line(ray_fx_x1+2, ray_fx_y1, ray_fx_x2+2, ray_fx_y2);
		draw_line(ray_fx_x1-2, ray_fx_y1, ray_fx_x2-2, ray_fx_y2);
        px = nx; py = ny;
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}

shader_reset();