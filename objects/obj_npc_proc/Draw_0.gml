draw_sprite(body_sprite, body_frame, x, y + visual_y_offset);
draw_sprite(cloth_sprite, cloth_frame, x, y + visual_y_offset);
draw_sprite(hair_sprite, hair_frame, x, y + visual_y_offset);

if (hair_frame != -1){
    draw_sprite(hair_sprite, hair_frame, x, y + visual_y_offset);
}

