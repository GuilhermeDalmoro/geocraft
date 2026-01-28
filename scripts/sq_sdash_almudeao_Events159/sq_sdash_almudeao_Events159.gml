
function sq_sdash_almudeao_Moment()
{
    var _dialogo = instance_create_layer(0, 0, "Instances", obj_dialogo)
    with (_dialogo) {
    	_dialogo.npc_nome = "missao1_king_arts"
    global.dialogo_acontecendo = true; 
    setar_camera();
    } 
 }






function sq_sdash_almudeao_Moment_1()
{
       var _dialogo = instance_create_layer(0, 0, "Instances", obj_dialogo)
       with (_dialogo) {
       	_dialogo.npc_nome = "missao1_king_arts1"
       global.dialogo_acontecendo = true; 
   }
}



function sq_sdash_almudeao_Moment_2()
{
    instance_destroy(obj_revolver)
    
    
}




function sq_sdash_almudeao_Moment_3() {
        var _dialogo = instance_create_layer(0, 0, "Instances", obj_dialogo)
     with (_dialogo) {
       	_dialogo.npc_nome = "missao1_king_arts2"
       global.dialogo_acontecendo = true; 
    }
    
    global.missao1_terminou = true;
}


