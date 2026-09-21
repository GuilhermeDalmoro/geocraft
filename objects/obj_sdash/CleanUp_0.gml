if (variable_instance_exists(id, "inimigos_atingidos")
&& ds_exists(inimigos_atingidos, ds_type_list)) {
    ds_list_destroy(inimigos_atingidos);
}
