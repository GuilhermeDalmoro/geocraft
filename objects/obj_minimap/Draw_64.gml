if (!map_visible) exit;

// Interfaces grandes ganham prioridade visual.
if (global.pause || global.dialogo_acontecendo) exit;

if (!surface_exists(map_surface)) {
    if (!map_rebuild()) exit;
}

if (!instance_exists(obj_sdash)) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _draw_expanded = expanded;

// O overlay tecnico do F10 usa o lado direito; nesse caso o mapa volta
// temporariamente ao modo compacto para nao virar uma parede de UI.
if (variable_global_exists("game_state")
&& is_struct(global.game_state)
&& global.game_state.runtime.debug_open) {
    _draw_expanded = false;
}

var _panel_w = _draw_expanded ? min(expanded_w, _gw - 40) : compact_w;
var _panel_h = _draw_expanded ? min(expanded_h, _gh - 40) : compact_h;

var _panel_x = _draw_expanded
    ? (_gw - _panel_w) * 0.5
    : _gw - _panel_w - panel_margin;

var _panel_y = _draw_expanded
    ? 20
    : panel_margin;

var _footer_h = _draw_expanded ? 28 : 0;

var _map_x = _panel_x + 8;
var _map_y = _panel_y + header_h + 4;
var _map_w = _panel_w - 16;
var _map_h = _panel_h - header_h - 12 - _footer_h;

// Moldura cubica.
draw_set_alpha(0.92);
draw_set_color(make_color_rgb(12, 14, 24));
draw_rectangle(
    _panel_x,
    _panel_y,
    _panel_x + _panel_w,
    _panel_y + _panel_h,
    false
);

draw_set_alpha(1);
draw_set_color(make_color_rgb(255, 125, 190));
draw_rectangle(
    _panel_x + 2,
    _panel_y + 2,
    _panel_x + _panel_w - 2,
    _panel_y + _panel_h - 2,
    true
);

draw_set_color(make_color_rgb(42, 44, 60));
draw_rectangle(
    _map_x - 2,
    _map_y - 2,
    _map_x + _map_w + 2,
    _map_y + _map_h + 2,
    false
);

// Cabecalho.
draw_set_font(fnt_dialogo_small);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_yellow);
draw_text(_panel_x + 10, _panel_y + 8, "MAPA");

draw_set_color(c_white);
draw_text(
    _panel_x + 54,
    _panel_y + 8,
    room_get_name(room)
);

draw_set_halign(fa_right);
draw_set_color(c_gray);
draw_text(
    _panel_x + _panel_w - 10,
    _panel_y + 8,
    _draw_expanded ? "[TAB] fechar" : "[TAB] ampliar"
);
draw_set_halign(fa_left);

// Janela do mundo em torno do jogador.
var _player = instance_find(obj_sdash, 0);

var _view_world_w = _draw_expanded
    ? min(room_width, 1500)
    : min(room_width, 720);

var _view_world_h = _view_world_w * (_map_h / max(1, _map_w));

if (_view_world_h > room_height) {
    _view_world_h = room_height;
    _view_world_w = min(
        room_width,
        _view_world_h * (_map_w / max(1, _map_h))
    );
}

var _view_x = clamp(
    _player.x - _view_world_w * 0.5,
    0,
    max(0, room_width - _view_world_w)
);

var _view_y = clamp(
    _player.y - _view_world_h * 0.5,
    0,
    max(0, room_height - _view_world_h)
);

var _src_x = _view_x * map_scale_x;
var _src_y = _view_y * map_scale_y;
var _src_w = max(1, _view_world_w * map_scale_x);
var _src_h = max(1, _view_world_h * map_scale_y);

draw_set_alpha(1);
draw_set_color(c_white);

draw_surface_part_ext(
    map_surface,
    _src_x,
    _src_y,
    _src_w,
    _src_h,
    _map_x,
    _map_y,
    _map_w / _src_w,
    _map_h / _src_h,
    c_white,
    1
);

// Guardamos a transformacao para os WITHs de marcadores.
draw_view_x = _view_x;
draw_view_y = _view_y;
draw_view_w = _view_world_w;
draw_view_h = _view_world_h;
draw_map_x = _map_x;
draw_map_y = _map_y;
draw_map_w = _map_w;
draw_map_h = _map_h;

// Inimigos.
with (obj_par_inimigos) {
    if (x >= other.draw_view_x
    && x <= other.draw_view_x + other.draw_view_w
    && y >= other.draw_view_y
    && y <= other.draw_view_y + other.draw_view_h) {

        var _sx = other.draw_map_x
            + ((x - other.draw_view_x) / other.draw_view_w) * other.draw_map_w;

        var _sy = other.draw_map_y
            + ((y - other.draw_view_y) / other.draw_view_h) * other.draw_map_h;

        draw_set_color(make_color_rgb(255, 78, 88));
        draw_rectangle(_sx - 2, _sy - 2, _sx + 2, _sy + 2, false);
    }
}

// NPCs principais.
with (obj_par_npc) {
    if (x >= other.draw_view_x
    && x <= other.draw_view_x + other.draw_view_w
    && y >= other.draw_view_y
    && y <= other.draw_view_y + other.draw_view_h) {

        var _sx = other.draw_map_x
            + ((x - other.draw_view_x) / other.draw_view_w) * other.draw_map_w;

        var _sy = other.draw_map_y
            + ((y - other.draw_view_y) / other.draw_view_h) * other.draw_map_h;

        draw_set_color(make_color_rgb(80, 220, 225));
        draw_rectangle(_sx - 2, _sy - 2, _sx + 2, _sy + 2, false);
    }
}

// NPCs procedurais, menores.
with (obj_npc_proc) {
    if (x >= other.draw_view_x
    && x <= other.draw_view_x + other.draw_view_w
    && y >= other.draw_view_y
    && y <= other.draw_view_y + other.draw_view_h) {

        var _sx = other.draw_map_x
            + ((x - other.draw_view_x) / other.draw_view_w) * other.draw_map_w;

        var _sy = other.draw_map_y
            + ((y - other.draw_view_y) / other.draw_view_h) * other.draw_map_h;

        draw_set_color(make_color_rgb(105, 205, 130));
        draw_rectangle(_sx - 1, _sy - 1, _sx + 1, _sy + 1, false);
    }
}

// Fornalhas.
with (obj_fornalha) {
    if (x >= other.draw_view_x
    && x <= other.draw_view_x + other.draw_view_w
    && y >= other.draw_view_y
    && y <= other.draw_view_y + other.draw_view_h) {

        var _sx = other.draw_map_x
            + ((x - other.draw_view_x) / other.draw_view_w) * other.draw_map_w;

        var _sy = other.draw_map_y
            + ((y - other.draw_view_y) / other.draw_view_h) * other.draw_map_h;

        draw_set_color(make_color_rgb(255, 145, 50));
        draw_rectangle(_sx - 2, _sy - 2, _sx + 2, _sy + 2, false);
    }
}

// Loja.
with (obj_loja) {
    if (x >= other.draw_view_x
    && x <= other.draw_view_x + other.draw_view_w
    && y >= other.draw_view_y
    && y <= other.draw_view_y + other.draw_view_h) {

        var _sx = other.draw_map_x
            + ((x - other.draw_view_x) / other.draw_view_w) * other.draw_map_w;

        var _sy = other.draw_map_y
            + ((y - other.draw_view_y) / other.draw_view_h) * other.draw_map_h;

        draw_set_color(make_color_rgb(219, 112, 255));
        draw_rectangle(_sx - 2, _sy - 2, _sx + 2, _sy + 2, false);
    }
}

// Jogador por ultimo: sempre legivel.
var _player_sx = _map_x
    + ((_player.x - _view_x) / _view_world_w) * _map_w;

var _player_sy = _map_y
    + ((_player.y - _view_y) / _view_world_h) * _map_h;

draw_set_color(c_black);
draw_rectangle(
    _player_sx - 4,
    _player_sy - 4,
    _player_sx + 4,
    _player_sy + 4,
    false
);

draw_set_color(c_yellow);
draw_rectangle(
    _player_sx - 2,
    _player_sy - 2,
    _player_sx + 2,
    _player_sy + 2,
    false
);

// Pequeno indicador da direcao do Sdash.
var _dir_angle = variable_instance_exists(_player, "veloc_dir")
    ? _player.veloc_dir
    : 0;

draw_line(
    _player_sx,
    _player_sy,
    _player_sx + lengthdir_x(7, _dir_angle),
    _player_sy + lengthdir_y(7, _dir_angle)
);

if (_draw_expanded) {
    draw_set_halign(fa_left);
    draw_set_color(c_yellow);
    draw_text(_panel_x + 12, _panel_y + _panel_h - 24, "Sdash");

    draw_set_color(make_color_rgb(80, 220, 225));
    draw_text(_panel_x + 76, _panel_y + _panel_h - 24, "NPC");

    draw_set_color(make_color_rgb(255, 78, 88));
    draw_text(_panel_x + 126, _panel_y + _panel_h - 24, "Inimigo");

    draw_set_color(make_color_rgb(255, 145, 50));
    draw_text(_panel_x + 210, _panel_y + _panel_h - 24, "Fornalha");

    draw_set_color(make_color_rgb(219, 112, 255));
    draw_text(_panel_x + 298, _panel_y + _panel_h - 24, "Loja");
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
