/// obj_distort_controller Destroy
if (ds_list_exists(dist_waves)) {
    ds_list_destroy(dist_waves);
}
if (surface_exists(surface_distort)) {
    surface_free(surface_distort);
}
