if (mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id)) {
    global.lingua = (global.lingua == "pt-br") ? "en" : "pt-br";
    image_index = (global.lingua == "pt-br") ? 0 : 1; // Atualiza sprite
}