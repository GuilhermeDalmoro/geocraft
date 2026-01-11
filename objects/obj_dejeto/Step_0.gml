if terminou_dialogo == true{
    //show_message("terminou o dialogo")
    //flag pra dizer se ja aconteceu
    pos_dialogo = true
    
    terminou_dialogo = false
}

if pos_dialogo && !king_spawwnado {
    king_spawwnado = true
    king_ref = instance_create_layer(king_spaww_x, king_spaww_y, "Instances", obj_king_art)
    
    setar_camera(0.03);
    
    with (king_ref) {
        sprite_index = spr_king_art_correndo;
        image_xscale = -0.8;
        image_yscale = 0.8;
    	
    }
    
}

if (king_spawwnado && instance_exists(king_ref) && !king_chegou){
    
    king_ref.x += king_vel;
    
    if king_ref.x >= king_target_x{
        king_chegou = true
        
        with (king_ref) {
        	sprite_index = spr_art_king;
            image_xscale = -0.8;
            image_yscale = 0.8;
        }
        // vai executar resetar_camera(0.003); em 3 segundos apos
        alarm[0] = 70
        }
    }