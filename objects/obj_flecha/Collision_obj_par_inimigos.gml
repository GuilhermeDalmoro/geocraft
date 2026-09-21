var _dano = variable_instance_exists(id, "dano") ? dano : 3;
var _dir = point_direction(x, y, other.x, other.y);

other.empurrar_dir = _dir;
other.empurrar_veloc = 4;
other.hit = true;
other.vida -= _dano;

if (other.object_index != obj_boss_andrius) {
    other.alarm[1] = 5;
    other.estado = scr_art_hit;
}

var _inst = instance_create_layer(x, y, "Instances", obj_dano_highlight);
_inst.alvo = other;
_inst.dano = _dano;

scr_screen_shake(other.object_index == obj_boss_andrius ? 5 : 10, 4);
instance_destroy();
