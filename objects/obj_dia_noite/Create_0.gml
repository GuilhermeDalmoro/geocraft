//criando minha surface
surf = noone;

//momento do dia
momento = 0;

//efeito de escurecer
dia_noite = function(){
	momento = (sin(.2 * get_timer() / 1000000) +1) / 2;
	
	//checando se a minha surface existe
	if (surface_exists(surf)){
			
		//vou desenhar na minha surface
		surface_set_target(surf);
	
		//garantindo que a minha surface esta limpa
		draw_clear_alpha(c_black,0);
		
		draw_set_color(c_black);
		draw_set_alpha(min(momento, 0.75));
		draw_rectangle(0,0,room_width, room_height, false);
		draw_set_alpha(1);
		draw_set_color(-1);
		
		//desenhando um buraco onde tem o poste/luz
		if (instance_exists(obj_luz)){
			with(obj_luz){
				gpu_set_blendmode(bm_subtract);
				
				var _tamanho = 25 + variacao
				//primeira luz
				draw_set_alpha(.8)
				draw_circle(x, y -20, _tamanho , false)
				//segunda luz
				draw_set_alpha(.5)
				draw_circle(x, y -20, _tamanho + 10, false)
				//terceira luz
				draw_set_alpha(.3)
				draw_circle(x, y -20, _tamanho + 15, false)
				 //resetando o alfa
				draw_set_alpha(1);
				
				gpu_set_blendmode(bm_normal);
			}
		}
		
		//parei de desenhar na minha surface
		surface_reset_target();
		
		
		//se a surface existe, entao eu desenho ela
		draw_surface(surf, 0, 0);
		
	}else{
		//se a minha surface nao existe entao eu crio ela
		surf = surface_create(room_width, room_height)
	
	}
}