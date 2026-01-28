if (!montado) {
    sprite_index = sprite_idle;
    image_speed = 1;
}
else {

    // INPUT
    var h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var v = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    hveloc = h * vel;
    vveloc = v * vel;

    //DIREÇÃO DA SPRITE
    if (h > 0) image_xscale = -1;
    if (h < 0) image_xscale = 1;

    //sprite andando ou parado
    if (h != 0 || v != 0) {
        sprite_index = sprite_run;
        image_speed = 1;
    } 
    else {
        sprite_index = sprite_idle;
        image_speed = 1;
    }

    //COLISÃO HORIZONTAL (IGUAL SDASH)
    if (place_meeting(x + hveloc, y, obj_parede or obj_arvore)) {
        while (!place_meeting(x + sign(hveloc), y, obj_parede)) {
            x += sign(hveloc);
        }
        hveloc = 0;
    }
    x += hveloc;

    //COLISÃO VERTICAL (IGUAL SDASH)
    if (place_meeting(x, y + vveloc, obj_parede)) {
        while (!place_meeting(x, y + sign(vveloc), obj_parede)) {
            y += sign(vveloc);
        }
        vveloc = 0;
    }
    y += vveloc;

    //posiciona o sdash em cima
    if (instance_exists(cavaleiro)) {
        cavaleiro.x = x;
        cavaleiro.y = y - 10;

        if (h > 0) cavaleiro.sprite_index = spr_sdash_parado_direita;
        if (h < 0) cavaleiro.sprite_index = spr_sdash_parado_esquerda;
    }
}
