x = room_width / 2 - 150;
y = room_height / 2;
var _new_menu = [
    { text: "Pergaminhos", action: function() { room_goto(room_pergaminhos); } },
    { text: "Personagens", action: function() { room_goto(room_personagens); } },
    { text: "Créditos", action: function() { room_goto(room_creditos); } }
];
obj_menu.current_menu = _new_menu;
obj_menu.menu_index = 0;
obj_menu.option_y_offset = array_create(array_length(_new_menu), -100);
obj_menu.option_scale = array_create(array_length(_new_menu), 1);
obj_menu.option_stretch = array_create(array_length(_new_menu), 1);
obj_menu.reset_animations();