// ---- NECESSIDADES ----
need_social   = irandom_range(30, 100);
need_rest     = irandom_range(30, 100);
need_wander   = irandom_range(30, 100);

flee_from = noone;
talk_target = noone;
talk_timer = 0;

// ---- PERSONALIDADE ----
bravery = irandom_range(20, 80); // coragem
sociable = irandom_range(20, 80); // sociabilidade


// ---- IDENTIDADE ----
npc_id = irandom(999999);

// ---- FUNÇÃO ----
role = choose(NPC_ROLE.CIVIL, NPC_ROLE.MERCHANT, NPC_ROLE.GUARD);

// ---- APARÊNCIA (FRAME ALEATÓRIO) ----
body_sprite = spr_npc_body_0;
body_frame  = irandom(sprite_get_number(body_sprite) - 1);

hair_sprite = spr_npc_cabelo_0;
hair_frame  = irandom(sprite_get_number(hair_sprite) - 1);

cloth_sprite = spr_npc_roupa_0;
cloth_frame  = irandom(sprite_get_number(cloth_sprite) - 1);

// ---- ESTADO ----
state = NPC_STATE.IDLE;

// ---- MOVIMENTO ----
speed_walk = 0.5;
target_x = x;
target_y = y;
wait_time = irandom_range(60, 200);

image_xscale = choose(-1, 1);
image_yscale = 1;

visual_y_offset = irandom_range(-1, 2);

if (random(100) < 15) hair_frame = -1;




/// FUNÇÃO PRA FRAME COM PESO
function choose_weighted(_arr, _weights) {
    var sum = 0;
    for (var i = 0; i < array_length(_weights); i++) sum += _weights[i];

    var r = random(sum);
    var acc = 0;

    for (var i = 0; i < array_length(_arr); i++) {
        acc += _weights[i];
        if (r < acc) return _arr[i];
    }

    return _arr[0];
}
