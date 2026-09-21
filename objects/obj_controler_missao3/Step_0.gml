if (!cutscene_tocada) {

    // toca a sequence
    seq_inst = layer_sequence_create( "Instances", 0, 0, sq_andrius_abertura);

    cutscene_tocada = true;
}
else {

    // quando a sequence terminar
    if (!layer_sequence_exists("Instances" ,seq_inst)) {

        // SPAWN DO BOSS
        //instance_create_layer( room_width / 2, room_height / 2, "Instances", obj_boss_andrius);

        // remove o controlador
        instance_destroy();
    }
}
