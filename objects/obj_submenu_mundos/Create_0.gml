x = room_width / 2 - 150;
y = room_height / 2;
var _new_menu = [
    { text: "Fácil", action: function() { room_goto(room_facil); } },
    { text: "Hardcore", action: function() { room_goto(room_hardcore); } },
    { text: "Construção", action: function() { room_goto(room_construcao); } }
];
obj_menu.current_menu = _new_menu;
obj_menu.menu_index = 0;
obj_menu.option_y_offset = array_create(array_length(_new_menu), -100); // Reinicia offsets
obj_menu.option_scale = array_create(array_length(_new_menu), 1); // Reinicia escalas
obj_menu.option_stretch = array_create(array_length(_new_menu), 1); // Reinicia stretch
obj_menu.reset_animations();