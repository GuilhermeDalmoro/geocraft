if (variable_instance_exists(id, "fornalha_slots")) {
    if (ds_exists(fornalha_slots, ds_type_grid)) {
        ds_grid_destroy(fornalha_slots);
    }
}
