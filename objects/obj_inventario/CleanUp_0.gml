// Libera a grid somente quando a instancia principal esta realmente saindo.
// Duplicatas sao destruidas antes de criarem uma grid propria.
if (instance_number(obj_inventario) <= 1) {
    if (variable_global_exists("inventario_slots")
    && ds_exists(global.inventario_slots, ds_type_grid)) {
        ds_grid_destroy(global.inventario_slots);
    }
}
