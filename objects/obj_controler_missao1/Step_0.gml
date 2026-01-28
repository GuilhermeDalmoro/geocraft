// CRIA A SEQUENCE UMA ÚNICA VEZ
if (missao_comecou && !seq_criada) {

    var _sdash = instance_find(obj_sdash, 0);
    if (_sdash == noone) exit;

    sq_element = layer_sequence_create(
        "sequences",
        _sdash.x,
        _sdash.y,
        sq_sdash_almudeao
    );

    var _sq_inst = layer_sequence_get_instance(sq_element);

    sequence_instance_override_object(
        _sq_inst,
        obj_sdash,
        _sdash
    );

    seq_criada = true;
}


// FINAL DA MISSÃO — LIBERA O SDASH
if (global.missao1_terminou && sq_element != noone) {

    layer_sequence_destroy(sq_element);
    sq_element = noone;

    instance_destroy(); // opcional, mata o controlador
}
