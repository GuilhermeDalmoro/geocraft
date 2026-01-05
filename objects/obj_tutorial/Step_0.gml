if instance_exists(obj_sdash) and global.tutorial = false{
	var _dialogo = instance_create_layer(0, 0, "Dialogo", obj_dialogo);
    _dialogo.npc_nome = "boas_vindas";
    global.dialogo_acontecendo = true;
    instance_destroy();
}


