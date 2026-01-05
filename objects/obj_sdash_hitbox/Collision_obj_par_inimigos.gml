/// @description Insert description here
other.vida -= obj_sdash.dano;

var _dir = point_direction(obj_sdash.x, obj_sdash.y, other.x, other.y);
other.empurrar_dir = _dir;
other.empurrar_veloc = 6;
other.estado = scr_art_hit;

other.alarm[1] = 5;
other.hit = true;

var _inst = instance_create_layer(x ,y, "Instances", obj_dano_highlight);
_inst.alvo = other;
_inst.dano = obj_sdash.dano;

scr_screen_shake(15,5);