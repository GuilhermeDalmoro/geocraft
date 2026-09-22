var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

draw_set_font(fnt_dialogo_small);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// HUD compacto da missao rastreada.
var _tracked = gc_quest_get_tracked();

if (_tracked != noone
&& !global.pause
&& !global.game_state.runtime.quest_journal_open) {
    var _x = 18;
    var _y = 18;
    var _w = 360;
    var _h = 96;

    draw_set_alpha(0.84);
    draw_set_color(c_black);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_alpha(1);

    draw_set_color(c_yellow);
    draw_text(_x + 12, _y + 8, _tracked.nome);

    draw_set_color(c_white);
    var _line = _y + 31;
    var _shown = 0;

    if (variable_struct_exists(_tracked, "objetivos") && is_array(_tracked.objetivos)) {
        for (var _i = 0; _i < array_length(_tracked.objetivos); _i++) {
            var _o = _tracked.objetivos[_i];

            if (!_o.complete && _shown < 2) {
                draw_text(
                    _x + 12,
                    _line,
                    "- " + _o.label + "  " + string(_o.current) + "/" + string(_o.required)
                );

                _line += 20;
                _shown++;
            }
        }
    }

    if (_shown == 0) {
        draw_set_color(c_lime);
        draw_text(_x + 12, _line, "Objetivos completos");
    }

    draw_set_color(c_gray);
    draw_text(_x + 12, _y + 74, "[M] Diario de missoes");
}

// Notificacao curta de progresso.
if (!global.pause
&& global.game_state.runtime.toast_timer > 0
&& string_length(global.game_state.runtime.toast_text) > 0) {

    var _tw = min(680, string_width(global.game_state.runtime.toast_text) + 40);
    var _tx = (_gw - _tw) * 0.5;
    var _ty = 24;

    draw_set_alpha(0.92);
    draw_set_color(c_black);
    draw_rectangle(_tx, _ty, _tx + _tw, _ty + 38, false);
    draw_set_alpha(1);

    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_text(_gw * 0.5, _ty + 10, global.game_state.runtime.toast_text);
    draw_set_halign(fa_left);
}

// Diario completo.
if (global.game_state.runtime.quest_journal_open) {
    draw_set_alpha(0.94);
    draw_set_color(make_color_rgb(18, 20, 32));
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    draw_set_color(c_yellow);
    draw_text(48, 28, "DIARIO DE MISSOES");

    draw_set_color(c_white);
    draw_text(48, 54, "W/S ou setas: selecionar   ENTER: rastrear   M/ESC: fechar");

    var _visible = gc_quest_get_visible();
    var _count = array_length(_visible);

    if (_count <= 0) {
        draw_set_color(c_gray);
        draw_text(58, 105, "Nenhuma missao descoberta ainda.");
    }
    else {
        journal_selected = clamp(journal_selected, 0, _count - 1);

        // Janela simples: mostra ate 6 missoes em volta da selecao.
        var _first = max(0, journal_selected - 2);
        var _last = min(_count - 1, _first + 5);

        if (_last - _first < 5) {
            _first = max(0, _last - 5);
        }

        var _yq = 92;

        for (var _qidx = _first; _qidx <= _last; _qidx++) {
            var _q = _visible[_qidx];
            var _selected = (_qidx == journal_selected);

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

            if (_selected) {
                draw_set_alpha(0.30);
                draw_set_color(c_white);
                draw_rectangle(42, _yq - 6, _gw - 42, _yq + 88, false);
                draw_set_alpha(1);
            }

            draw_set_color(_status_color);

            var _prefix = _selected ? "> " : "  ";
            draw_text(54, _yq, _prefix + "[" + _status_text + "] " + _q.nome);

            draw_set_color(c_white);
            draw_text_ext(74, _yq + 23, _q.descricao, 18, _gw - 160);

            var _yo = _yq + 48;

            if (variable_struct_exists(_q, "objetivos") && is_array(_q.objetivos)) {
                for (var _oi = 0; _oi < array_length(_q.objetivos); _oi++) {
                    var _o = _q.objetivos[_oi];

                    draw_set_color(_o.complete ? c_lime : c_white);

                    var _mark = _o.complete ? "[OK] " : "[ ] ";

                    draw_text(
                        82,
                        _yo,
                        _mark
                        + _o.label
                        + " ("
                        + string(_o.current)
                        + "/"
                        + string(_o.required)
                        + ")"
                    );

                    _yo += 18;
                }
            }

            if (_selected
            && (_q.status == "ativa" || _q.status == "pronta")
            && global.game_state.runtime.tracked_quest_id == _q.id_m) {
                draw_set_color(c_aqua);
                draw_text(_gw - 190, _yq, "RASTREADA");
            }

            _yq += 102;

            if (_yq > _gh - 50) break;
        }
    }
}

// Overlay tecnico para desenvolvimento.
if (global.game_state.runtime.debug_open && !global.pause) {
    var _dx = _gw - 370;
    var _dy = 205;

    draw_set_alpha(0.88);
    draw_set_color(c_black);
    draw_rectangle(_dx, _dy, _gw - 20, _dy + 190, false);
    draw_set_alpha(1);

    draw_set_color(c_aqua);
    draw_text(_dx + 12, _dy + 8, "GAME STATE DEBUG");

    draw_set_color(c_white);
    draw_text(_dx + 12, _dy + 34, "Room: " + room_get_name(room));
    draw_text(_dx + 12, _dy + 54, "Etapa: " + string(global.game_state.campaign.stage));
    draw_text(_dx + 12, _dy + 74, "Moedas: " + string(global.moedas));
    draw_text(_dx + 12, _dy + 94, "Inimigos: " + string(global.inimigos_mortos));
    draw_text(_dx + 12, _dy + 114, "Cavalos: " + string(global.cabalos_alimentados));
    draw_text(_dx + 12, _dy + 134, "Missoes concluidas: " + string(gc_state_counter_get("missoes_concluidas", 0)));
    draw_text(_dx + 12, _dy + 154, "Construcoes: " + string(gc_state_counter_get("construcoes_feitas", 0)));
    draw_text(_dx + 12, _dy + 174, "F9 DEV MODE");
}


draw_set_alpha(1);

    draw_set_color(c_fuchsia);
    draw_text(_dev_x + 12, _dev_y + 8, "DEV MODE ON");

    draw_set_color(c_white);
    draw_text(_dev_x + 12, _dev_y + 30, "F1  +100 moedas");
    draw_text(_dev_x + 12, _dev_y + 50, "F2  +materiais para testes");
    draw_text(_dev_x + 12, _dev_y + 70, "F3  cura + estamina");
    draw_text(_dev_x + 12, _dev_y + 90, "F4  desbloquear magias");
    draw_text(_dev_x + 12, _dev_y + 110, "F6  concluir missao rastreada");
    draw_text(_dev_x + 12, _dev_y + 130, "F8  salvar | setas E/D: teleportes antigos");
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
