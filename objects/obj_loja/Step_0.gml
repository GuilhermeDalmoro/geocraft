if (!instance_exists(obj_sdash)) exit;

var _player = instance_find(obj_sdash, 0);
var _near = point_distance(x, y, _player.x, _player.y) <= 42;

if (_near
&& !global.pause
&& !global.dialogo_acontecendo
&& !instance_exists(obj_shop_int_1)
&& (keyboard_check_pressed(ord("F"))
    || gamepad_button_check_pressed(global.controle, gp_face2))) {

    instance_create_depth(0, 0, -100000, obj_shop_int_1);
}
