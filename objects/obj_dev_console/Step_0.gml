if (open_lock > 0) open_lock--;

global.pause = true;

if (variable_global_exists("game_state") && is_struct(global.game_state)) {
    global.game_state.runtime.pause = true;
    global.game_state.runtime.dev_mode = true;
    global.game_state.runtime.modal_ui = "dev_console";
}

// Fecha.
if (open_lock <= 0
&& (keyboard_check_pressed(vk_f9) || keyboard_check_pressed(vk_escape))) {
    dev_close();
    exit;
}

var _tab_left = keyboard_check_pressed(ord("Q")) || keyboard_check_pressed(vk_pageup);
var _tab_right = keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_pagedown);

if (_tab_left) {
    tab = (tab - 1 + array_length(tabs)) mod array_length(tabs);
    selected = 0;
    scroll = 0;
}

if (_tab_right) {
    tab = (tab + 1) mod array_length(tabs);
    selected = 0;
    scroll = 0;
}

var _count = dev_row_count();

if (_count <= 0) {
    selected = 0;
    scroll = 0;
}
else {
    if (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up)) {
        selected = max(0, selected - 1);
    }

    if (keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down)) {
        selected = min(_count - 1, selected + 1);
    }

    if (mouse_wheel_up()) {
        selected = max(0, selected - 1);
    }

    if (mouse_wheel_down()) {
        selected = min(_count - 1, selected + 1);
    }

    if (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left)) {
        dev_edit(-1, false);
    }

    if (keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right)) {
        dev_edit(1, false);
    }

    if (keyboard_check_pressed(vk_enter)
    || gamepad_button_check_pressed(global.controle, gp_face1)) {
        dev_edit(0, true);
    }

    // Mantem selecao visivel.
    if (selected < scroll) scroll = selected;
    if (selected >= scroll + visible_rows) {
        scroll = selected - visible_rows + 1;
    }

    scroll = clamp(scroll, 0, max(0, _count - visible_rows));
}


// =====================================================
// MOUSE
// =====================================================

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _panel_x = 24;
var _panel_y = 22;
var _panel_w = _gw - 48;
var _panel_h = _gh - 44;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Tabs.
var _tab_x = _panel_x + 18;
var _tab_y = _panel_y + 58;
var _tab_gap = (_panel_w - 36) / array_length(tabs);

for (var _t = 0; _t < array_length(tabs); _t++) {
    var _x1 = _tab_x + _t * _tab_gap;
    var _x2 = _x1 + _tab_gap - 4;

    if (point_in_rectangle(_mx, _my, _x1, _tab_y, _x2, _tab_y + 32)
    && mouse_check_button_pressed(mb_left)) {
        tab = _t;
        selected = 0;
        scroll = 0;
        _count = dev_row_count();
    }
}

// Rows.
var _row_x1 = _panel_x + 28;
var _row_x2 = _panel_x + _panel_w - 28;
var _row_y = _panel_y + 112;
var _row_h = 37;

for (var _v = 0; _v < visible_rows; _v++) {
    var _row = scroll + _v;

    if (_row >= _count) break;

    var _y1 = _row_y + _v * _row_h;
    var _y2 = _y1 + 31;

    if (point_in_rectangle(_mx, _my, _row_x1, _y1, _row_x2, _y2)) {
        selected = _row;

        if (mouse_check_button_pressed(mb_left)) {
            // Menos.
            if (_mx >= _row_x2 - 150 && _mx < _row_x2 - 100) {
                dev_edit(-1, false);
            }
            // Mais.
            else if (_mx >= _row_x2 - 50) {
                dev_edit(1, false);
            }
            // Centro / acao.
            else {
                dev_edit(0, true);
            }
        }
    }
}
