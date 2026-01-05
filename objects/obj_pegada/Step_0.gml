// No evento Step
if (keyboard_check_pressed(ord("F"))) {
    reset_alpha = true; // Ativa o estado de reset
}

if (reset_alpha) {
    image_alpha = 0; // Mantém o alpha em 0
} else if (distance_to_object(obj_sdash) <= 20) {
    image_alpha = 1;
} else {
    image_alpha = 0;
}
