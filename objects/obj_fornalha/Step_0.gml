if (!instance_exists(obj_sdash)) exit;

var _dist = point_distance(x, y, obj_sdash.x, obj_sdash.y);

if (_dist < 40 && keyboard_check_pressed(ord("F"))) {
    aberto = !aberto;
    //global.pause = aberto;
};