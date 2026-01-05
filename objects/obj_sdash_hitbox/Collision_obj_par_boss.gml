/// @description Insert description here
other.vida -= obj_sdash.dano;

var _dir = point_direction(obj_sdash.x, obj_sdash.y, other.x, other.y);
other.empurrar_dir = _dir;
other.empurrar_veloc = 6;
other.estado = scr_art_hit;

other.alarm[1] = 5;
other.hit = true;

scr_screen_shake(15,5);