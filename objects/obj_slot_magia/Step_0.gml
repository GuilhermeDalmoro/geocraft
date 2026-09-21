if (!instance_exists(obj_sdash)) exit;
if (global.pause) exit;

var _player = instance_find(obj_sdash, 0);

// SPACE percorre apenas magias desbloqueadas.
if (keyboard_check_pressed(vk_space)) {
    var _start = global.magia_selecionada;

    if (_start == noone) _start = -1;

    var _found = false;
    var _candidate = _start;

    repeat (num_slots) {
        _candidate = (_candidate + 1) mod num_slots;

        if (is_array(global.tem_magia) && global.tem_magia[_candidate]) {
            global.magia_selecionada = _candidate;
            selected = _candidate;
            _found = true;
            break;
        }
    }

    if (_found) {
        gc_quest_toast(
            "Magia: " + gc_magic_name(global.magia_selecionada),
            55
        );

        tocar_som_efeito(snd_blip_select, 1, 1);
    }
}

// 1..5 selecionam diretamente.
for (var _i = 0; _i < num_slots; _i++) {
    if (keyboard_check_pressed(ord(string(_i + 1)))) {
        if (is_array(global.tem_magia) && global.tem_magia[_i]) {
            global.magia_selecionada = _i;
            selected = _i;

            gc_quest_toast(
                "Magia: " + gc_magic_name(_i),
                55
            );

            tocar_som_efeito(snd_blip_select, 1, 1);
        }
        else {
            gc_quest_toast(
                "Magia " + string(_i + 1) + " ainda bloqueada",
                55
            );
        }
    }
}

// SHIFT guarda a magia.
if (keyboard_check_pressed(vk_shift)) {
    global.magia_selecionada = noone;
}

// Mantemos as escalas para compatibilidade com codigo antigo.
for (var _s = 0; _s < num_slots; _s++) {
    var _target = (global.magia_selecionada == _s) ? 1.35 : 1;
    escala[_s] = lerp(escala[_s], _target, 0.22);
    escala_alvo[_s] = _target;
}
