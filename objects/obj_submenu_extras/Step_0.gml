if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mouse_x, mouse_y, x, y - 20, x + 150, y + 20)) {
        room_goto(room_pergaminhos);
    } else if (point_in_rectangle(mouse_x, mouse_y, x + 150, y - 20, x + 300, y + 20)) {
        room_goto(room_personagens);
    } else if (point_in_rectangle(mouse_x, mouse_y, x + 300, y - 20, x + 450, y + 20)) {
        room_goto(room_creditos);
    }
}