// scr_textos_en, this script holds all the in-game texts, but in a more chill English
function scr_textos_en() {
    switch (npc_nome) {
		
		case "boas_vindas":
	    ds_grid_add_text("Hello, welcome to [cor=amarelo] [pulsar] Geocraft", spr_ret_criador, 0, "Sdash");
	    ds_grid_add_text("You can walk using \n [cor=amarelo] WASD", spr_ret_criador, 0, "Sdash");
		ds_grid_add_text("To attack you can use the [cor=vermelho] left button mouse", spr_ret_criador, 0, "Sdash");
		ds_grid_add_text("To use [cor=amarelo] dash [/cor] you can use [cor=roxo] right button mouse", spr_ret_criador, 0, "Sdash");
		ds_grid_add_text("To interact you can [cor=amarelo] Press the F key", spr_ret_criador, 0, "Sdash");
		ds_grid_add_text("To open your inventory you can [cor=amarelo] press the E key", spr_ret_criador, 0, "Sdash");
		ds_grid_add_text("Don't worry, the game will guide you when you need it.", spr_ret_criador, 0, "Sdash");
	    ds_grid_add_text("[cor=vermelho] But be careful who you talk to \n He is powerful", spr_ret_criador_puto, 0, "Sdash");
		global.tutorial = true;
        if (variable_global_exists("game_state") && is_struct(global.game_state)) {
            global.game_state.campaign.unlocks.tutorial = true;
        }
	    break;
		
		
        case "PC_Fim":
            ds_grid_add_text("Holy SHIT, I [pulsar][cor=verde]hacked " + string(global.pc_score) + " dejetos[/cor][/pulsar][semefeito]!", spr_ret_sdash_normal, 0, "Sdash");
            break;
			
        case "Primeiro Texto":
            ds_grid_add_text("This [pulsar][cor=roxo] excrement [/cor][/pulsar][semefeito] [flutuar] sings [/flutuar][semefeito] the [onda][cor=azul] anthem [/cor][/onda][semefeito] of the [tremor] invasion [/tremor][semefeito]... spooky.", spr_ret_reia, 1, "Sign");
            ds_grid_add_text("What the [abalo][cor=vermelho] heck [/cor][/abalo][semefeito] is this thing? [bounce][/bounce][semefeito] Who [zoom][cor=amarelo] dumped [/cor][/zoom][semefeito] it here?!", spr_ret_sdash_paralisado, 0, "Sdash");
            break;
			
        case "janela":
            ds_grid_add_text("When the rock broke, your name echoed through the ruins... kinda deep.", spr_ret_sdash_emotivo, 1, "Sdash");
            ds_grid_add_text("Staring out the window gives me purpose. For real.", spr_ret_sdash_emotivo, 1, "Sdash");
            break;
			
        case "suba a escada":
            ds_grid_add_text("Climb on up, buddy :) ", spr_escada, 0, "LADDER");
            break;
			
        case "placa cobre":
            ds_grid_add_text("[semefeito] Check this out: [/semefeito] [cor=amarelo][onda] past presidents [/cor][/onda][semefeito] of Cubic Land [/semefeito]", spr_ret_reia, 0, "Copper Sign");
            ds_grid_add_text("Town halls hiding something... stop slacking and go find it", spr_ret_reia, 0, "Copper Sign");
            ds_grid_add_text("....", spr_ret_sdash_paralisado, 1, "Sdash");
            ds_grid_add_text("Yeah, whoever made this sign probably hates outsiders", spr_ret_reia, 0, "Copper Sign");
            ds_grid_add_text("Yeah, Im just now realizing Cubic Land’s got some [flutuar][cor=roxo] weird humor", spr_ret_sdash_levando_vantagi, 1, "Sdash");
            break;
			
        case "Segundo Texto":
            ds_grid_add_text("Yo, what are you doing here?..", spr_ret_sdash_normal, 0, "Sdash");
            ds_grid_add_text("I dunno, just chillin around...", spr_ret_king_arts_normal, 1, "King of Art's");
            ds_grid_add_text("Wait...  [zoom]WHAT THE HECK IS THAT?! [/zoom][semefeito]Sdash, you didnt touch that [/semefeito] [cor=roxo] dejeto [semefeito] right? [/semefeito]", spr_ret_king_arts_normal, 1, "King of Art's");
            ds_grid_add_text("Well.... I kinda ate some of it, now I feel... weird [pulsar][cor=vermelho] I guess..", spr_ret_sdash_normal, 0, "Sdash");
            ds_grid_add_text("Sdash... YOU DUMMY, MEET ME AT THE STABLE, I’M TELLING [cor=amarelo] ALMUDEAO [/cor][semefeito] ABOUT THIS! [/semefeito]", spr_ret_king_arts_bravo, 0, "King of Art's");
            gc_state_area_set(1, true);
        gc_quest_start("m001_almudeao");
            break;
			
        case "Texto treino":
            ds_grid_add_text("Alright Sdash, lets do some training", spr_ret_king_arts_normal, 1, "King of Art's");
            ds_grid_add_text("Heck yeah!! What do I do?", spr_ret_sdash_normal, 0, "Sdash");
            ds_grid_add_text("Use your... mouse to smack stuff and dash! Take out those pesky things, thats your first job", spr_ret_king_arts_normal, 1, "King of Art's");
            ds_grid_add_text("Wanna take the first mission?", spr_ret_king_arts_normal, 1, "King of Art's");
            add_op("Sure, I’m in", "rsp 1");
            add_op("Nah bro, I’m good", "rsp 2");
            break;
			
        case "rsp 1":
            gc_quest_start("treino_gmd");
            ds_grid_add_text("Let's go then!", spr_ret_king_arts_bravo, 1, "King of Art's");
            ds_grid_add_text("Before that, take this magic and bow.", spr_ret_king_arts_bravo, 1, "King of Art's");

            var _inst = instance_create_layer(x + 8, y - 9, "Instances", obj_item);
            _inst.item = global.itens[| ITENS.arco];

            gc_state_magic_set(0, true);
            ds_grid_add_text("[cor=amarelo] [flutuar] To open missions, hit M", spr_ret_reia, 0, "Notice");
            gc_state_reputation_add("lealdade", -3);
            break;
			
        case "rsp 2":
            ds_grid_add_text("Alrighty then", spr_ret_king_arts_bravo, 0, "King of Art's");
            gc_state_reputation_add("lealdade", -1);
            break;
			
        case "Texto treino pag 2":
            ds_grid_add_text("AWESOME JOB SDASH, YOU DID IT!!", spr_ret_king_arts_orgulhoso, 1, "King of Art's");
gc_quest_complete("treino_gmd");
            gc_quest_start("alimentar_cavalos");
            ds_grid_add_text("Youre all set now, Sdash. Wait for me at the stable, well go feed Almudeao’s horses:", spr_ret_king_arts_orgulhoso, 1, "King of Art's");
            break;
			
        case "Cavalos texto":
            ds_grid_add_text("IRRHOOOO, IRHOOOO", spr_ret_cavalos, 1, "Horse");
            ds_grid_add_text("Dude, speak normal words please", spr_ret_sdash_normal, 0, "Sdash");
            ds_grid_add_text("Gimme food", spr_ret_cavalos, 1, "Horse");
            ds_grid_add_text("Hit control to feed them", spr_ret_reia, 1, "Sign");
            break;
			
        case "Cavalos texto easter egg":
            ds_grid_add_text("Lately I saw this dude...  he did weird stuff to me... had like 2050 armies...", spr_ret_cavalos_safado, 1, "Cavalifero");
            ds_grid_add_text("Wait... who was it?", spr_ret_sdash_normal, 0, "Sdash");
            ds_grid_add_text("Name started with C... don’t remember.. sorry bro :(", spr_ret_cavalos, 1, "Cavalifero");
            break;
			
        case "oloco":
            ds_grid_add_text("Finish the mission to keep going", spr_ret_reia, 1, "Test");
            break;
			
        case "Missao Cavalos":
            ds_grid_add_text("Hey Sdash, I gotta tell you something....", spr_almudeao_frente, 1, "Almudeao");
            ds_grid_add_text("W-what... ;--;", spr_ret_sdash_normal, 0, "Sdash");
            ds_grid_add_text("Its not serious, right?", spr_ret_sdash_emotivo, 0, "Sdash");
            ds_grid_add_text("Nah, just a lil [flutuar]unexpected situation[/flutuar]...", spr_almudeao_frente, 1, "Almudeao");
            ds_grid_add_text("I'll explain later, first go grab some grass, feed the horses, pick one and untie it", spr_almudeao_frente, 1, "Almudeao");
            ds_grid_add_text("[cor=amarelo] [flutuar] [bounce] Get close to a horse and press Control to feed it", spr_ret_reia, 1, "Sign");
            add_op("Ok Im going", "resp1cav");
            break;
			
        case "resp1cav":
            gc_quest_start("alimentar_cavalos");
            ds_grid_add_text("Nice!", spr_almudeao_frente, 1, "Almudeao");
            break;
			
        case "Almudeao_Bloqueado":
            ds_grid_add_text("Hey Sdash! Before helping the horsies, take out those shape dudes in Room 2, go go! [fim]", spr_ret_sdash_normal, 0, "Sdash");
            break;
			
        case "Sir gritado":
            ds_grid_add_text("YO SDASH! DID YOU KNOW THE GREATEST ADVENTURE IS... A BIRD THAT FLIES?! GET IT? AVE-N-TURE! LOOOLLL!", spr_sir_gritado, 1, "Sir Shouter");
            ds_grid_add_text("Youre one loyal cube, huh!", spr_sir_gritado, 1, "Sir Shouter");
            ds_grid_add_text("Dude... can you quit yelling and actually help me?", spr_ret_sdash_levando_vantagi, 0, "Sdash");
            ds_grid_add_text("I GOT NO HELP BUT YOU CAN CHILL AT MY PLACE IF YA WANT", spr_sir_gritado, 1, "Sir Shouter");
            break;
			
        case "Professor pei 1":
            ds_grid_add_text("Hey I'm Mr. Paytowin", spr_ret_senhor_pei, 1, "Mr. Paytowin");
            ds_grid_add_text("Wanna buy some maps or potions?", spr_ret_senhor_pei, 1, "Mr. Paytowin");
            add_op("Yup", "resposta sim");
            add_op("Nope", "resposta nao");
            break;
			
        case "dona petunia":
            ds_grid_add_text("Hello little Sdash, where is the Almudeao?", spr_ret_dona_petunia_normal, 1, "Mrs. Petunia");
            ds_grid_add_text("Hello Mrs. Petunia how are you? How’s the garden?", spr_ret_sdash_emotivo, 0, "Sdash");
            ds_grid_add_text("Oh Sdash Im fine and today I decided to plant Tomatoes and Potatoes, would you like some?", spr_ret_dona_petunia_normal, 1, "Mrs. Petunia");
            add_op("Yes please, but what do they do?", "nome faz1");
            add_op("No thanks but thank you", "nome faz2");
            break;
			
        case "nome faz1":
            ds_grid_add_text("Eating the tomato restores 8 HP, while the potato gives you an extra 4 body fat!", spr_ret_dona_petunia_feliz, 1, "Mrs. Petunia");
            ds_grid_add_text("Here you go!", spr_ret_dona_petunia_feliz, 1, "Mrs. Petunia");
            instance_create_layer(x + 6, y - 12, "Instances", obj_farinacio_trigo);
            break;
			
        case "nome faz2":
            ds_grid_add_text("Alright then!", spr_ret_dona_petunia_feliz, 1, "Mrs. Petunia");
            break;
			
        case "quadro1":
            ds_grid_add_text("This is just a painting", spr_quadro, 1, "Painting");
            break;
			
        case "espelho1":
            ds_grid_add_text("Its me, ... Sdash", spr_espelho, 1, "Mirror");
            break;
			
        case "easter egg daniel fraga 1":
            ds_grid_add_text("Tax evasion is a must", spr_ret_reia, 1, "Daniel Fraga");
            break;
			
        case "Missao_Concluida":
            ds_grid_add_text("Damn, [zoom][cor=amarelo] I feel POWERFUL [/cor][/zoom][semefeito]!!", spr_ret_sdash_normal, 0, "Sdash");
            break;
			
        case "Missao2_Concluida":
            ds_grid_add_text("Yay another task done for my master ^_^", spr_ret_sdash_normal, 0, "Sdash");
            break;
			
        case "Item Toque":
            ds_grid_add_text("[onda][cor=amarelo] Chaos created kings. You were born in the shard.", spr_ret_sdash_normal, 0, "Sdash");
            ds_grid_add_text("[onda][cor=amarelo] Game saved", spr_ret_sdash_normal, 0, "Sdash");
            break;
			
    }
}