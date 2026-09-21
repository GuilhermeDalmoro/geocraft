function scr_boss_escolher_ataque() {
    if (alarm[0] <= 0 && comecou_luta) {
        estado = choose(
            scr_boss_ataque1,
            scr_boss_ataque2,
            scr_boss_ataque3,
            scr_boss_ataque4
        );

        var _delay = 100;

        if (variable_instance_exists(id, "fase_boss")) {
            if (fase_boss == 2) _delay = 75;
            if (fase_boss >= 3) _delay = 50;
        }

        alarm[0] = _delay;
    }
}

function scr_boss_ataque1() {
    // ANEL GEOMETRICO: projeteis em 360 graus.
    sprite_index = spr_andrius_boss;

    var _count = 8 + (fase_boss - 1) * 4;
    var _step = 360 / _count;

    for (var _i = 0; _i < _count; _i++) {
        var _proj = instance_create_layer(
            x,
            y,
            "Instances",
            obj_boss_andrius_projetil
        );

        _proj.speed = 3.3 + fase_boss * 0.35;
        _proj.direction = _i * _step;
    }

    estado = scr_boss_escolher_ataque;
}

function scr_boss_ataque2() {
    // MINIONS: quantidade cresce a cada fase.
    sprite_index = spr_andrius_estado_minions;

    var _count = 2 + fase_boss;
    var _step = 360 / _count;

    for (var _i = 0; _i < _count; _i++) {
        var _minion = instance_create_layer(
            x,
            y,
            "Instances",
            obj_minion_andrius_1
        );

        _minion.speed = 0.8 + fase_boss * 0.2;
        _minion.direction = _i * _step;
        _minion.image_xscale = 0.5;
        _minion.image_yscale = 0.5;
    }

    sprite_index = spr_andrius_boss;
    estado = scr_boss_escolher_ataque;
}

function scr_boss_ataque3() {
    // BOMBARDEIO: cria perigos ao redor do jogador/arena.
    sprite_index = spr_andrius_boss;

    var _count = 2 + fase_boss;

    repeat (_count) {
        var _xx = clamp(
            x + irandom_range(-170, 170),
            24,
            room_width - 24
        );

        var _yy = clamp(
            y + irandom_range(-170, 170),
            24,
            room_height - 24
        );

        instance_create_layer(
            _xx,
            _yy,
            "Instances",
            obj_boss_andrius_ataque_2
        );
    }

    estado = scr_boss_escolher_ataque;
}

function scr_boss_ataque4() {
    // NUMEROS MALDITOS: outro anel, mais lento e colorido.
    sprite_index = spr_andrius_estado_minions;

    var _count = 6 + fase_boss * 2;
    var _step = 360 / _count;

    for (var _i = 0; _i < _count; _i++) {
        var _number = instance_create_layer(
            x,
            y,
            "Instances",
            obj_numeros
        );

        _number.sprite_index = spr_numeros;
        _number.speed = 0.8 + fase_boss * 0.15;
        _number.direction = _i * _step;
        _number.image_xscale = 0.5;
        _number.image_yscale = 0.5;
        _number.image_blend = choose(
            c_purple,
            c_green,
            c_red,
            c_blue,
            c_orange
        );
    }

    sprite_index = spr_andrius_boss;
    estado = scr_boss_escolher_ataque;
}
