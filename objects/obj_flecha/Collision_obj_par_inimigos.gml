var _dano = 2;
var _dir = point_direction(x, y, other.x, other.y);

other.empurrar_dir = _dir;
other.empurrar_veloc = 4;
other.hit = true;
other.alarm[1] = 5;
other.estado = scr_art_hit;
other.vida -= _dano;
 var _inst = instance_create_layer(x ,y, "Instances", obj_dano_highlight);
_inst.alvo = other;
_inst.dano = _dano;
instance_destroy();