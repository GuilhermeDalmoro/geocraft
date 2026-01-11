var inimigo = instance_nearest(x, y, obj_par_inimigos);

if (inimigo != noone) {
    var d = point_distance(x, y, inimigo.x, inimigo.y);

    if (d < 50 && bravery < 60) {
        state = NPC_STATE.FLEE;
    }

}


need_social += 0.01;
need_rest   += 0.005;
need_wander += 0.008;

need_social = clamp(need_social, 0, 100);
need_rest   = clamp(need_rest, 0, 100);
need_wander = clamp(need_wander, 0, 100);

if (state == NPC_STATE.IDLE) {

    // Quer conversar
    if (need_social > 70 && sociable > 50) {
        var outro = instance_nearest(x, y, obj_npc_proc);
        if (outro != noone && outro != id && point_distance(x,y,outro.x,outro.y) < 40) {
            state = NPC_STATE.TALK;
            talk_target = outro;
            need_social -= 40;
        }
    }

    // Quer andar
    else if (need_wander > 60) {
        state = NPC_STATE.WALK;
        need_wander -= 30;
    }
}

if (need_wander > 70) {
    var poi = instance_nearest(x, y, obj_interest_well);
    if (poi != noone) {
        target_x = poi.x;
        target_y = poi.y;
        state = NPC_STATE.WALK;
        need_wander -= 40;
    }
}


if (state == NPC_STATE.WALK) {
    if (place_meeting(x, y, obj_parede)) {
        target_x = x + irandom_range(-32, 32);
        target_y = y + irandom_range(-32, 32);
    }
}



switch (state) {

    case NPC_STATE.TALK:

    if (!instance_exists(talk_target)) {
        state = NPC_STATE.IDLE;
        break;
    }

    // Ficam parados se olhando
    image_xscale = sign(talk_target.x - x);

    talk_timer++;

    if (talk_timer > 120) {
        talk_timer = 0;
        state = NPC_STATE.IDLE;
    }

break;

    case NPC_STATE.IDLE:
        wait_time--;
        if (wait_time <= 0) {
            target_x = x + irandom_range(-64, 64);
            target_y = y + irandom_range(-64, 64);
            state = NPC_STATE.WALK;
        }
    break;

    case NPC_STATE.WALK:
    var dx = target_x - x;
    var dy = target_y - y;
    
    var hsp = clamp(dx, -speed_walk, speed_walk);
    var vsp = clamp(dy, -speed_walk, speed_walk);
    
    npc_move_with_collision(hsp, vsp);
    
    if (point_distance(x, y, target_x, target_y) < 2) {
        state = NPC_STATE.IDLE;
        wait_time = irandom_range(60, 180);
    }
    
    break;

    case NPC_STATE.FLEE:

    if (!instance_exists(flee_from)) {
        state = NPC_STATE.IDLE;
        break;
    }

    var dx = x - flee_from.x;
    var dy = y - flee_from.y;

    var len = point_distance(0, 0, dx, dy);
    if (len != 0) {
        dx /= len;
        dy /= len;
    }

    var flee_dist = 50;

    target_x = x + dx * flee_dist;
    target_y = y + dy * flee_dist;

    // ---- LIMITES DA ROOM ----
    target_x = clamp(target_x, 0, room_width);
    target_y = clamp(target_y, 0, room_height);
    var hsp = dx * speed_walk * 1.5;
    var vsp = dy * speed_walk * 1.5;
    
    npc_move_with_collision(hsp, vsp);
    

    // Se já está longe o suficiente
    if (point_distance(x, y, flee_from.x, flee_from.y) > 70) {
        state = NPC_STATE.IDLE;
        wait_time = irandom_range(60, 200);
    }

break;
}


x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height);
