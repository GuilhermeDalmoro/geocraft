var border_l = x - (global.borda_largura_arena / 2);
var border_r = x + (global.borda_largura_arena / 2);
var border_u = y - (global.borda_altura_arena / 2);
var border_d = y + (global.borda_altura_arena / 2);

obj_sdash_icon.x = clamp(obj_sdash_icon.x, border_l + 8, border_r - 8);
obj_sdash_icon.y = clamp(obj_sdash_icon.y, border_u + 8, border_d - 8);

draw_set_color(c_white);
draw_rectangle(border_l - 4, border_u - 4, border_r + 4, border_d + 4, false);
draw_set_color(c_black);
draw_rectangle(border_l, border_u, border_r, border_d, false);

draw_set_font(fnt_ui_batalha);
draw_set_color(c_yellow);
draw_text(border_l, border_u - 32, "Vida Sdash: " + string(global.vida_arena_sdash) + " / 20");

//if (instance_exists(global.inimigo[0]) && global.inimigo[0].mostrar_vida) {
//    draw_set_color(c_red);
//    var _vida_porcentagem = global.inimigo[0].vida / global.inimigo[0].vida_max;
//    draw_rectangle(display_get_width() - 150, 100, display_get_width() - 50, 120, false);
//    draw_set_color(c_green);
//    draw_rectangle(display_get_width() - 150, 100, display_get_width() - 150 + 100 * _vida_porcentagem, 120, false);
//    draw_set_color(c_white);
//    draw_text(display_get_width() - 150, 80, global.inimigo[0].nome_boss + ": " + string(global.inimigo[0].vida) + " / " + string(global.inimigo[0].vida_max));
//}