function npc_move_with_collision(_hspeed, _vspeed) {

    // Horizontal
    if (_hspeed != 0) {
        if (!place_meeting(x + _hspeed, y, obj_parede)) {
            x += _hspeed;
        }
    }

    // Vertical
    if (_vspeed != 0) {
        if (!place_meeting(x, y + _vspeed, obj_parede)) {
            y += _vspeed;
        }
    }
}
