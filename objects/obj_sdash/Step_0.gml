if (!active) exit;

// Enquanto montado, o cavalo controla o movimento. R desmonta com seguranca.
if (montado) {
    if (!instance_exists(meu_cavalo)) {
        montado = false;
        meu_cavalo = noone;
    }
    else {
        if (keyboard_check_pressed(ord("R"))) {
            var _horse = meu_cavalo;

            montado = false;
            meu_cavalo = noone;

            _horse.montado = false;
            _horse.cavaleiro = noone;

            x = clamp(_horse.x + 18, 0, room_width);
            y = clamp(_horse.y, 0, room_height);

            gc_quest_toast("Sdash desmontou", 55);
        }
        else {
            audio_listener_position(x, y, 0);
            exit;
        }
    }
}
    
script_execute(estado);

depth = -y;

#region Ferramenta

if (keyboard_check_pressed(ord("C")) or gamepad_axis_value(global.controle, gp_shoulderlb)) {
    ferramenta_selecionada = !ferramenta_selecionada;
        if (ferramenta_selecionada) {
            
            arma = noone;
        } else {
            arma = ARMAS.Espada;
    }
}

segura_ferramenta();

seletor();

#endregion

#region Estamina

if alarm[1] <= 0{
    estamina += 1;
}

estamina = clamp(estamina, 0, max_estamina);

#endregion

#region Dialogo

if (!global.dialogo_acontecendo){
    if distance_to_object(obj_par_npc)<= 15 {
        if keyboard_check_pressed(ord("F")) or gamepad_button_check_pressed(global.controle,gp_face2){
            global.dialogo_acontecendo = true
    var _npc = instance_nearest(x,y,obj_par_npc);
    var _dialogo = instance_create_layer(x,y, "Dialogo", obj_dialogo);
        _dialogo.npc_nome = _npc.nome;
        _dialogo.npc_ref = _npc
        }
    }
}

#endregion

#region Magia

if (magia_cooldown > 0) {
    magia_cooldown--;
}

if (!global.pause && keyboard_check_pressed(ord("Z"))) {
    gc_magic_cast(id, global.magia_selecionada);
}

#endregion

#region Morte

if (vida <= 0) {
    active = false;
    instance_destroy();
    room_goto(Room_game_over);
    exit;
}

#endregion
#region trocar arma
//if keyboard_check_pressed(ord("R")){
// arma += 1;
//}
//if keyboard_check_pressed(ord("Q")){
// arma -=1;
//}
//if arma >= ARMAS.Altura{
//arma = 0;
//}else if arma < 0{
// arma = ARMAS.Altura - 1;
//}

#endregion

#region Empurrar bloco
// empurrando blocos
    var push_list = ds_list_create();
    var _tem_bloco_h = instance_place_list(x + hveloc, y, obj_bloco_movel, push_list, false);
    var _tem_bloco_v = instance_place_list(x , y + vveloc, obj_bloco_movel, push_list, false);

    if (_tem_bloco_h){
        if(ds_list_size(push_list) > 0){
            for(var i = 0; i < ds_list_size(push_list); i++){
                var bloco = push_list[| i];
                    with(bloco){
    if(!place_meeting(x+other.hveloc, y, obj_parede)){
        x+= other.hveloc;
                    }
                }
            }
        }
    }

if (_tem_bloco_v){
    
if(ds_list_size(push_list) > 0){
    
    for(var i = 0; i < ds_list_size(push_list); i++){
    
        var bloco = push_list[| i];
    with(bloco){
    if(!place_meeting(x, y +other.vveloc, obj_parede)){
    y+= other.vveloc;
                }
            }
        }
    }
}

ds_list_destroy(push_list);

#endregion

#region //provisorio pra usar os itens
 //if global.item_player = global.itens[| ITENS.arco]{
// arma = ARMAS.Arco;
 //}
 //if global.item_player = global.itens[| ITENS.espadalv1]{
// arma = ARMAS.Espada;
 //}
 #endregion
#region Outros
 //XP
// xp++;
 //if keyboard_check_pressed(vk_space){
 //xp += 100;
 //}
 //if xp >= max_xp[insignia]{
//xp = xp - max_xp[insignia];
//insignia += 1;
 //}
if keyboard_check_pressed(ord("O")){
    instance_create_layer(x ,y, "Instances", obj_lootbox)
 }
 #endregion
#region fade
// Fade de transição simples – roda todo frame se tiver ativo
if (fade_estado == 1) { // Fechando
    fade_alpha += fade_vel;
    if (fade_alpha >= 1) {
        fade_alpha = 1;
        room_goto(target_sala);
        x = target_x;
        y = target_y;
        fade_estado = 2; // agora abre na nova sala
    }
}
if (fade_estado == 2) { // Abrindo
    fade_alpha -= fade_vel * 1.2; // abre um pouco mais rápido
    if (fade_alpha <= 0) {
        fade_alpha = 0;
        fade_estado = 0;
    }
}
#endregion
#region cavalos
if (!montado) {
    var cav = instance_place(x, y, obj_cavalos);
    if (cav != noone && keyboard_check_pressed(ord("R"))) {
        montado = true;
        meu_cavalo = cav;
        cav.montado = true;
        cav.cavaleiro = id;
        gc_quest_notify("montar", "cavalo", 1);
    }
}
else {
    // enquanto montado, não anda
    exit;
}
#endregion
// Teleportes de desenvolvimento nao ficam mais ativos na gameplay normal.
if (variable_global_exists("game_state") && is_struct(global.game_state)
&& global.game_state.runtime.dev_mode) {
    if (keyboard_check_pressed(vk_right)) {
        room_goto(Room_dentro_masmorra);
    }
    if (keyboard_check_pressed(vk_left)) {
        room_goto(Room5);
    }
}
#region Jukebox
audio_listener_position(x, y, 0);
#endregion