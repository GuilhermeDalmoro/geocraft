if (!instance_exists(obj_sdash)) exit;

var _player = instance_find(obj_sdash, 0);
var _near = point_distance(x, y, _player.x, _player.y) <= 42;

var _interaction_ready = true;

if (variable_global_exists("game_state") && is_struct(global.game_state)) {
    if (variable_struct_exists(global.game_state.runtime, "interaction_lock")) {
        _interaction_ready = (global.game_state.runtime.interaction_lock <= 0);
    }
}

if (_near
&& _interaction_ready
&& !global.pause
&& !global.dialogo_acontecendo
&& !instance_exists(obj_shop_int_1)
&& (keyboard_check_pressed(ord("F"))
    || gamepad_button_check_pressed(global.controle, gp_face2))) {

    instance_create_depth(0, 0, -100000, obj_shop_int_1);
}
