if (!map_visible) exit;

if (!global.pause
&& !global.dialogo_acontecendo
&& keyboard_check_pressed(vk_tab)) {
    expanded = !expanded;
}

if (cached_room != room || !surface_exists(map_surface)) {
    map_rebuild();
}
