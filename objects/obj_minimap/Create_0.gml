if (instance_number(obj_minimap) > 1) {
    instance_destroy();
    exit;
}

// Create Event
// Configura as propriedades do minimapa pra mostrar a room inteira

// Tamanho do minimapa (50% da tela, ajustável)
minimap_width = 400;  // Largura do minimapa
minimap_height = 300; // Altura do minimapa

// Posição do minimapa (canto inferior direito)
minimap_x = display_get_gui_width() - minimap_width - 10; // 10 pixels da direita
minimap_y = display_get_gui_height() - minimap_height - 10; // 10 pixels da base

// Calcula a escala pra caber a room inteira no minimapa
scale_x = minimap_width / room_width;  // Escala horizontal
scale_y = minimap_height / room_height; // Escala vertical
scale = min(scale_x, scale_y); // Usa a menor pra evitar distorção

// Centraliza o conteúdo no minimapa (offset pra ajustar recorte)
offset_x = (minimap_width - room_width * scale) / 2; // Centraliza horizontalmente
offset_y = (minimap_height - room_height * scale) / 2; // Centraliza verticalmente

// Cor de fundo (preto)
bg_color = c_black;

// Cor dos tiles (cinza claro, mais visível)
tile_color = make_color_rgb(160, 160, 160); // #A0A0A0

// Transparência do minimapa (fundo e objetos)
alpha = 0.6;
