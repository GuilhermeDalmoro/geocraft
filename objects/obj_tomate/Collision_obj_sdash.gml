// Setar meu_id se não setado
if (meu_id == 0 && variable_instance_exists(id, "item")) {
    meu_id = item.id;
}

// Adicionar ao inventário
if (adiciona_ao_inventario(meu_id, qtd)) {
    instance_destroy();
    instance_create_layer(x, y, "Instances", obj_brilho);
}