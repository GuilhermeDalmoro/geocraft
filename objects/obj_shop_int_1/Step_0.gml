if (fechando) exit;

if (open_lock > 0) open_lock--;

global.pause = true;

if (variable_global_exists("game_state") && is_struct(global.game_state)) {
    global.game_state.runtime.pause = true;
    global.game_state.runtime.modal_ui = "loja";
}

var _count = array_length(itens_venda);

var _move =
    keyboard_check_pressed(ord("S"))
    + keyboard_check_pressed(vk_down)
    - keyboard_check_pressed(ord("W"))
    - keyboard_check_pressed(vk_up);

if (_move != 0) {
    index = clamp(index + sign(_move), 0, _count - 1);
    tocar_som_efeito(snd_blip_select, 1, 1);
}

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _w = min(680, _gw - 60);
var _h = min(500, _gh - 60);
var _x = (_gw - _w) * 0.5;
var _y = (_gh - _h) * 0.5;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _list_x1 = _x + 28;
var _list_x2 = _x + _w - 28;
var _start_y = _y + 118;
var _row_h = 52;

var _confirm =
    keyboard_check_pressed(vk_enter)
    || gamepad_button_check_pressed(global.controle, gp_face1);

for (var _i = 0; _i < _count; _i++) {
    var _row_y = _start_y + _i * _row_h;

    if (point_in_rectangle(
        _mx,
        _my,
        _list_x1,
        _row_y,
        _list_x2,
        _row_y + 44
    )) {
        index = _i;

        if (mouse_check_button_pressed(mb_left)) {
            _confirm = true;
        }
    }
}

if (_confirm) {
    var _sale = itens_venda[index];

    if (global.moedas < _sale.preco) {
        gc_quest_toast("Moedas insuficientes", 80);
        tocar_som_efeito(snd_blim, 1, 0.9);
    }
    else if (adiciona_ao_inventario(_sale.id, 1)) {
        global.moedas -= _sale.preco;
        gc_game_state_sync_from_legacy();

        gc_quest_notify("comprar", string(_sale.id), 1);
        gc_quest_notify("comprar", _sale.nome, 1);

        gc_quest_toast(
            "Comprou " + _sale.nome + " por " + string(_sale.preco) + " moedas",
            90
        );

        tocar_som_efeito(snd_blip_2, 1, 1.1);
    }
    else {
        gc_quest_toast("Inventario cheio", 90);
        tocar_som_efeito(snd_blim, 1, 0.9);
    }
}

var _close_hover = point_in_rectangle(
    _mx,
    _my,
    _x + _w - 52,
    _y + 14,
    _x + _w - 18,
    _y + 46
);

var _close =
    keyboard_check_pressed(vk_escape)
    || (
        open_lock <= 0
        && (
            keyboard_check_pressed(ord("F"))
            || gamepad_button_check_pressed(global.controle, gp_face2)
        )
    )
    || (_close_hover && mouse_check_button_pressed(mb_left));

if (_close) {
    fechando = true;
    global.pause = false;

    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        global.game_state.runtime.pause = false;

        if (variable_struct_exists(global.game_state.runtime, "modal_ui")
        && global.game_state.runtime.modal_ui == "loja") {
            global.game_state.runtime.modal_ui = "";
        }

        global.game_state.runtime.interaction_lock = 3;
    }

    instance_destroy();
}
