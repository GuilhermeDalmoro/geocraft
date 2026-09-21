if (!seguindo_mouse) exit;

var _dir_mouse = point_direction(obj_sdash.x, obj_sdash.y, mouse_x, mouse_y);
var _dist_mouse = point_distance(obj_sdash.x, obj_sdash.y, mouse_x, mouse_y);
_dist_mouse = min(_dist_mouse, dist_max); // Limita a 50 pixels

x = obj_sdash.x + lengthdir_x(_dist_mouse, _dir_mouse);
y = obj_sdash.y + lengthdir_y(_dist_mouse, _dir_mouse);

// Coloca a fornalha ao soltar
if (mouse_check_button_pressed(mb_left)) {
    var _fornalha = instance_create_layer(x, y, "Instances", obj_fornalha);
    _fornalha.sprite_index = spr_fornalha; // Sprite final
    instance_destroy(); // Destroy obj_place
    instance_create_depth(x, y, depth-10, obj_brilho); // Brilho de colocação
    //tocar_som_efeito(snd_place, 8, 1); // Som de "plop" cúbico
}