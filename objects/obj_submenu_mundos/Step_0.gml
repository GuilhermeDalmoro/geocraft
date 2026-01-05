if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mouse_x, mouse_y, x, y - 48, x + 96, y + 48)) {
        room_goto(room_facil);
    } else if (point_in_rectangle(mouse_x, mouse_y, x + 100, y - 48, x + 196, y + 48)) {
        room_goto(room_hardcore);
    } else if (point_in_rectangle(mouse_x, mouse_y, x + 200, y - 48, x + 296, y + 48)) {
        room_goto(room_construcao);
    }
}