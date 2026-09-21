var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

draw_set_font(fnt_dialogo_small);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// HUD compacto da missao rastreada.
var _tracked = gc_quest_get_tracked();

if (_tracked != noone && !global.game_state.runtime.quest_journal_open) {
    var _x = 18;
    var _y = 18;
    var _w = 330;
    var _h = 76;

    draw_set_alpha(0.82);
    draw_set_color(c_black);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_alpha(1);

    draw_set_color(c_yellow);
    draw_text(_x + 12, _y + 8, _tracked.nome);

    draw_set_color(c_white);
    var _line = _y + 32;
    var _shown = false;

    if (variable_struct_exists(_tracked, "objetivos") && is_array(_tracked.objetivos)) {
        for (var _i = 0; _i < array_length(_tracked.objetivos); _i++) {
            var _o = _tracked.objetivos[_i];
            if (!_o.complete) {
                draw_text(_x + 12, _line, _o.label + "  " + string(_o.current) + "/" + string(_o.required));
                _shown = true;
                break;
            }
        }
    }

    if (!_shown) {
        draw_set_color(c_lime);
        draw_text(_x + 12, _line, "Objetivos completos - volte ao responsavel");
    }

    draw_set_color(c_gray);
    draw_text(_x + 12, _y + 55, "[M] Diario de missoes");
}

// Notificacao curta de progresso.
if (global.game_state.runtime.toast_timer > 0
&& string_length(global.game_state.runtime.toast_text) > 0) {

    var _tw = min(620, string_width(global.game_state.runtime.toast_text) + 36);
    var _tx = (_gw - _tw) * 0.5;
    var _ty = 24;

    draw_set_alpha(0.9);
    draw_set_color(c_black);
    draw_rectangle(_tx, _ty, _tx + _tw, _ty + 36, false);
    draw_set_alpha(1);

    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_text(_gw * 0.5, _ty + 9, global.game_state.runtime.toast_text);
    draw_set_halign(fa_left);
}

// Diario completo.
if (global.game_state.runtime.quest_journal_open) {
    draw_set_alpha(0.92);
    draw_set_color(make_color_rgb(18, 20, 32));
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    draw_set_color(c_yellow);
    draw_text(48, 34, "DIARIO DE MISSOES");

    draw_set_color(c_white);
    draw_text(48, 62, "M para fechar");

    var _yq = 100;

    for (var _qidx = 0; _qidx < array_length(global.missoes); _qidx++) {
        var _q = global.missoes[_qidx];

        if (!is_struct(_q)) continue;
        if (variable_struct_exists(_q, "hidden") && _q.hidden) continue;
        if (_q.status == "bloqueada") continue;

        var _status_text = "";
        var _status_color = c_white;

        switch (_q.status) {
            case "ativa":
                _status_text = "ATIVA";
                _status_color = c_yellow;
            break;

            case "pronta":
                _status_text = "OBJETIVOS COMPLETOS";
                _status_color = c_lime;
            break;

            case "concluida":
                _status_text = "CONCLUIDA";
                _status_color = c_gray;
            break;
        }

        draw_set_color(_status_color);
        draw_text(58, _yq, "[" + _status_text + "] " + _q.nome);

        draw_set_color(c_white);
        draw_text_ext(74, _yq + 24, _q.descricao, 18, _gw - 150);

        var _yo = _yq + 50;

        if (variable_struct_exists(_q, "objetivos") && is_array(_q.objetivos)) {
            for (var _oi = 0; _oi < array_length(_q.objetivos); _oi++) {
                var _o = _q.objetivos[_oi];
                draw_set_color(_o.complete ? c_lime : c_white);
                var _mark = _o.complete ? "[OK] " : "[ ] ";
                draw_text(82, _yo, _mark + _o.label + " (" + string(_o.current) + "/" + string(_o.required) + ")");
                _yo += 22;
            }
        }

        _yq = _yo + 22;
        if (_yq > _gh - 80) break;
    }
}

// Overlay tecnico para desenvolvimento.
if (global.game_state.runtime.debug_open) {
    var _dx = _gw - 320;
    var _dy = 20;

    draw_set_alpha(0.86);
    draw_set_color(c_black);
    draw_rectangle(_dx, _dy, _gw - 20, _dy + 150, false);
    draw_set_alpha(1);

    draw_set_color(c_aqua);
    draw_text(_dx + 12, _dy + 8, "GAME STATE DEBUG");

    draw_set_color(c_white);
    draw_text(_dx + 12, _dy + 34, "Room: " + room_get_name(room));
    draw_text(_dx + 12, _dy + 54, "Moedas: " + string(global.moedas));
    draw_text(_dx + 12, _dy + 74, "Inimigos: " + string(global.inimigos_mortos));
    draw_text(_dx + 12, _dy + 94, "Cavalos alimentados: " + string(global.cabalos_alimentados));
    draw_text(_dx + 12, _dy + 114, "Missoes: " + string(array_length(global.missoes)));
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
