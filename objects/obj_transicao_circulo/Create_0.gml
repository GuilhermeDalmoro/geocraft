// obj_transicao_circulo - Create Event
// Só o efeito visual – não precisa de creation code!

raio      = 1024;           // valor inicial grande
estado    = 0;              // 0 = parado, 1 = fechando, 2 = trocou sala, 3 = abrindo
iniciado  = false;

destino_sala = noone;       // recebe na colisão
destino_x    = -1;
destino_y    = -1;

gui_w = display_get_gui_width();
gui_h = display_get_gui_height();
surface_trans = surface_create(gui_w, gui_h);