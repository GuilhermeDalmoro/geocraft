
if terminou_dialogo == true{
    //show_message("terminou o dialogo")
    
    
    //flag pra dizer se ja aconteceu
    pos_dialogo = true
    
    terminou_dialogo = false
}

if(pos_dialogo){ /// aqui dentro vai rodar oque vai acontecer dps q isso acontecer
    sprite_index = spr_king_art_correndo
    image_xscale = 0.8
    if x < room_width{
        x--;
        king_foi = true;
    }
}

