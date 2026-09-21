// Menu principal limpo. Objetos persistentes de gameplay sao removidos
// por global.voltar_menu() antes da troca de room.

global.pause = false;
global.pause_por_inventario = false;
global.dialogo_acontecendo = false;

if (instance_exists(obj_som)) {
    obj_som.msc_theme_menu.play = true;
}
