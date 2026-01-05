num_slots = 5;            // número de slots
raio = 30;                // distância entre centro e slot
centro_x = display_get_gui_width()/2;
centro_y = display_get_gui_height()/2;

selected = 0;             // slot selecionado
escala = array_create(num_slots, 1);     // escala atual de cada slot
escala_alvo = array_create(num_slots, 1); // escala desejada de cada slot
