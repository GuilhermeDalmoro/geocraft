if (global.missions[0].status == "active" && gmd_count < 3) {
    instance_create_layer(80, 80, "Instances", obj_gmd);
    instance_create_layer(85, 80, "Instances", obj_gmd);
    instance_create_layer(70, 80, "Instances", obj_gmd);
    gmd_count += 3; // Incrementa o contador por 3 (um pra cada instância)
}

//if (global.missions[0].status == "completed" && !global.dialogo_acontecendo) {
//    var _dialogo = instance_create_layer(0, 0, "Dialogo", obj_dialogo);
//    _dialogo.npc_nome = "Missao_Concluida";
//    global.dialogo_acontecendo = true;
//    global.pause = true;
//    instance_destroy(); // Destrói o objeto após completar
//}