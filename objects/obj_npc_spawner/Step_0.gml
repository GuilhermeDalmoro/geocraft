if (instance_number(obj_npc_proc) < spawn_max) {

    var xx = x + irandom_range(-radius, radius);
    var yy = y + irandom_range(-radius, radius);

    if (!place_meeting(xx, yy, obj_parede)) {
        var _npc = instance_create_layer(xx, yy, "Instances", obj_npc_proc);
        _npc.image_xscale = 1.5
        _npc.image_yscale = 1.5
        _npc.image_blend = random(99999999)
    }
}
