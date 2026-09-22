if (!global.pause_menu.active || global.dialogo_acontecendo) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

draw_set_alpha(bg_alpha);
draw_set_color(make_color_rgb(7, 8, 18));
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

var _panel_w = min(760, _gw - 100);
var _panel_h = min(560, _gh - 90);
var _px = (_gw - _panel_w) * 0.5;
var _py = (_gh - _panel_h) * 0.5;

draw_set_alpha(0.96);
draw_set_color(make_color_rgb(20, 20, 34));
draw_rectangle(_px, _py, _px + _panel_w, _py + _panel_h, false);

draw_set_alpha(1);
draw_set_color(make_color_rgb(255, 125, 190));
draw_rectangle(_px + 4, _py + 4, _px + _panel_w - 4, _py + _panel_h - 4, true);

draw_set_font(fnt_geocraft);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_color(c_black);
draw_text(_gw * 0.5 + 3, _py + 30 + 3, "PAUSADO");

draw_set_color(make_color_rgb(255, 125, 190));
draw_text(_gw * 0.5, _py + 30, "PAUSADO");

draw_set_font(fnt_dialogo_small);

if (pause_page == 0) {
    draw_set_halign(fa_left);

    var _mx = _px + 64;
    var _my = _py + 125;

    for (var _i = 0; _i < array_length(global.pause_menu.options); _i++) {
        var _yy = _my + _i * 58;
        var _selected = (_i == global.pause_menu.selected);

        draw_set_alpha(_selected ? 0.34 : 0.14);
        draw_set_color(_selected ? make_color_rgb(255, 125, 190) : c_black);
        draw_rectangle(_mx - 14, _yy - 12, _px + _panel_w * 0.57, _yy + 30, false);
        draw_set_alpha(1);

        draw_set_color(_selected ? c_yellow : c_white);
        draw_text(_mx, _yy, (_selected ? "> " : "  ") + global.pause_menu.options[_i]);
    }

    var _info_x = _px + _panel_w * 0.62;

    draw_set_color(c_aqua);
    draw_text(_info_x, _py + 135, "PARTIDA");

    draw_set_color(c_white);
    draw_text(_info_x, _py + 170, "Slot: " + string(global.save_slot));
    draw_text(_info_x, _py + 194, "Room: " + room_get_name(room));
    draw_text(_info_x, _py + 218, "Moedas: " + string(global.moedas));

    if (instance_exists(obj_sdash)) {
        var _s = instance_find(obj_sdash, 0);
        draw_text(_info_x, _py + 242, "Vida: " + string(_s.vida) + "/" + string(_s.max_vida));
        draw_text(_info_x, _py + 266, "Estamina: " + string(round(_s.estamina)) + "/" + string(_s.max_estamina));
    }

    var _tracked = gc_quest_get_tracked();

    draw_set_color(c_aqua);
    draw_text(_info_x, _py + 315, "MISSAO");

    draw_set_color(c_white);

    if (_tracked != noone) {
        draw_text_ext(_info_x, _py + 346, _tracked.nome, 18, _panel_w * 0.31);
    }
    else {
        draw_text(_info_x, _py + 346, "Nenhuma rastreada");
    }

    draw_set_color(c_gray);
    draw_text(_px + 64, _py + _panel_h - 52, "W/S + ENTER | ESC continua");
}
else {
    draw_set_halign(fa_center);

    draw_set_color(c_yellow);
    draw_text(_gw * 0.5, _py + 105, "OPCOES");

    var _difs = ["FACIL", "NORMAL", "DIFICIL"];
    var _rows = [
        "VOLUME: " + string(round(pause_volume * 100)) + "%",
        "TELA CHEIA: " + (pause_fullscreen ? "SIM" : "NAO"),
        "DIFICULDADE: " + _difs[global.dificuldade],
        "VOLTAR"
    ];

    var _oy = _py + 180;

    for (var _i = 0; _i < 4; _i++) {
        var _yy = _oy + _i * 70;
        var _selected = (_i == option_selected);

        draw_set_alpha(_selected ? 0.34 : 0.14);
        draw_set_color(_selected ? make_color_rgb(255, 125, 190) : c_black);
        draw_rectangle(_gw * 0.5 - 260, _yy - 12, _gw * 0.5 + 260, _yy + 32, false);
        draw_set_alpha(1);

        draw_set_color(_selected ? c_yellow : c_white);
        draw_text(_gw * 0.5, _yy, _rows[_i]);
    }

    draw_set_color(c_gray);
    draw_text(_gw * 0.5, _py + _panel_h - 52, "A/D altera | ENTER confirma | ESC volta");
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
