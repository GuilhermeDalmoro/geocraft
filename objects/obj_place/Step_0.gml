if (!seguindo_mouse) exit;

if (!instance_exists(obj_sdash)) {
    instance_destroy();
    exit;
}

var _player = instance_find(obj_sdash, 0);

var _dir_mouse = point_direction(_player.x, _player.y, mouse_x, mouse_y);
var _dist_mouse = min(
    point_distance(_player.x, _player.y, mouse_x, mouse_y),
    dist_max
);

// Colocacao em grade: combina melhor com o mundo cubico e evita coordenadas quebradas.
x = round((_player.x + lengthdir_x(_dist_mouse, _dir_mouse)) / 8) * 8;
y = round((_player.y + lengthdir_y(_dist_mouse, _dir_mouse)) / 8) * 8;

var _inside_room =
    x >= 8
    && y >= 8
    && x <= room_width - 8
    && y <= room_height - 8;

valid_place =
    _inside_room
    && !place_meeting(x, y, obj_parede)
    && !place_meeting(x, y, obj_arvore)
    && !place_meeting(x, y, obj_mineravel)
    && !place_meeting(x, y, obj_par_npc)
    && !place_meeting(x, y, obj_fornalha);

image_blend = valid_place ? c_white : c_red;

// Cancela sem perder material.
if (mouse_check_button_pressed(mb_right) || keyboard_check_pressed(vk_escape)) {
    gc_quest_toast("Construcao cancelada", 70);
    instance_destroy();
    exit;
}

if (mouse_check_button_pressed(mb_left)) {
    if (!valid_place) {
        gc_quest_toast("Nao da para construir aqui", 80);
        exit;
    }

    if (!is_struct(estrutura) || !tem_materiais(estrutura)) {
        gc_quest_toast("Materiais insuficientes", 100);
        instance_destroy();
        exit;
    }

    switch (build_kind) {
        case "fornalha":
            consome_materiais(estrutura);

            var _fornalha = instance_create_layer(x, y, "Instances", obj_fornalha);
            _fornalha.sprite_index = spr_fornalha;

            gc_world_structure_add(
                "fornalha",
                room_get_name(room),
                x,
                y
            );

            gc_state_counter_add("construcoes_feitas", 1);
            gc_quest_notify("construir", "fornalha", 1);

            instance_create_depth(x, y, depth - 10, obj_brilho);
            tocar_som_efeito(snd_blip_2, 8, 1);
            gc_quest_toast("Fornalha construida! Chegue perto e aperte F para usar.", 150);

            instance_destroy();
        break;

        default:
            gc_quest_toast("Estrutura ainda nao suportada", 100);
            instance_destroy();
        break;
    }
}
