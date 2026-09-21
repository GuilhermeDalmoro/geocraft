# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Geocraft** é um jogo 2D feito no **GameMaker** (project file: `Geocraft.yyp`). É um RPG de exploração com quebra de blocos, inventário, diálogo com NPCs, sistema de missões, batalha em turno, mini-games, crafting e insígnias. O idioma principal dos comentários e da UI do projeto é português brasileiro (pt-br), e o jogo também suporta inglês (carregado via `scr_textos_en` quando `global.lingua != "pt-br"`).

A pasta `notes/` contém documentação autoral sobre os principais sistemas e o enredo (35 missões planejadas) — vale a pena ler antes de mexer em sistemas documentados.

## Build / Run / Test

Não há CLI de build, linter nem suite de testes automatizados. O "build" é abrir o `Geocraft.yyp` no GameMaker Studio 2 (IDE) e usar **F5** (run) / **F6** (debug). Builds por plataforma vivem em `options/<plataforma>/` (windows, mac, linux, html5, android, ios, tvos, operagx, main).

Plataformas configuradas:
- `main` — config padrão
- `windows`, `mac`, `linux` — desktop
- `html5`, `operagx` — web
- `android`, `ios`, `tvos` — mobile

Não há `package.json`/`Makefile`/scripts de teste — qualquer verificação é feita rodando o jogo na IDE.

## Estrutura de Diretórios

```
Geocraft.yyp              # Arquivo do projeto GameMaker (NÃO editar à mão)
Geocraft.resource_order   # Ordem dos resources
objects/                  # 185 objetos (prefixo obj_*)
scripts/                  # 162 scripts (prefixo scr_*, funcoes_*, TGM_*, __scribble_*)
rooms/                    # 25 salas (Room1..N, *_cutscene, *_batalha, etc.)
sprites/                  # Sprites (prefixo spr_*)
fonts/                    # Fontes
sounds/                   # Áudios
paths/                    # Paths
tilesets/                 # Tilesets
particles/                # Sistemas de partículas
animcurves/               # Animation curves
sequences/                # Sequences (cutscenes, eventos)
shaders/                  # Shaders
options/                  # Configurações por plataforma
datafiles/                # Includes / fontes extras (ThaleahFat.ttf, alagard.ttf)
notes/                    # Documentação autoral em pt-br sobre os sistemas
```

## Arquitetura de Alto Nível

GameMaker é dirigido a eventos (Create / Step / Draw / Alarm / Collision / etc.) e o código é GML (GameMaker Language) com sintaxe similar a JS/C. A arquitetura do Geocraft mistura:

- **Controllers singleton-like**: `obj_data` (estado global), `obj_dialogo`, `obj_inventario`, `obj_controle_hud`, `obj_dia_noite`, `obj_pause`, controllers de missão, etc.
- **Globais via `global.*`**: tudo o que é cross-scene vai em `global.*`. Inicialização em `obj_data` Create + `scripts/funcoes_globais/funcoes_globais.gml`.
- **Enums de domínio** centralizam IDs: `ITENS`, `TIPO_ITENS`, `LISTA_CONSTRUCAO`, `LISTA_FORGE`, `ARMAS`, `Infosnpc`, `INSIGNIA_TIPO`, `NPC_ROLE`, `NPC_STATE`, `MENU_ESTADO`.
- **Pares (parent objects)**: `obj_par_npc`, `obj_par_inimigos`, `obj_par_boss` — filhos herdam o parent e especializam o comportamento.
- **Padrão constructor** para itens/insígnias/estruturas: `cria_item()`, `cria_materiais()`, `cria_estrutura()`, `Insignia()`.

### Bibliotecas embutidas (não mexer a menos que saiba o que está fazendo)

- **Scribble** (text rendering): `scripts/__scribble_*`, `folders/Scribble/`. Usado pelo `obj_dialogo` via `draw_text_effect(...)` (helper custom que parseia tags inline).
- **TurboGML** (otimizações): `scripts/TGM_*` (Arrays, AudioLoad, Cameras, Collisions, Data, Debug, Drawing, DsLists, Files, General, Graphics, Layers, Math, Matrix, Misc, Paths, ProceduralData, Raycasting, Strings, Structs, Tags, Vector, DimensionConversion).

### Enredo (resumo — `notes/Note3/Note3.txt` tem as 35 missões detalhadas)

- **Protagonista**: Sdash, herói que ganha o poder de "cubicidade" após ingerir detrito alienígena.
- **Mundo**: Cubic-Land, Indigenous-Land, Infernos-Land, Purpletrix.
- **Missão principal**: derrotar Reia e desvendar o segredo do "Geocraft".
- **NPCs-chave**: Almudeão (mentor), King of Arts (treinador), Dona Petúnia, Sdash, Reia.
- **Magias** (5): fogo (bola em espiral), água (chuva), raio (Vampire Survivors-like), planta (cura com custo de estamina), shooter (desbloqueada no castelo).
- **5 áreas** controladas por flags: `global.area_1`..`area_6`.

## Convenções do Projeto

- **Idioma do código**: nomes em pt-br (`obj_inventario`, `funcoes_globais`, `scr_textos`, `cria_item`, etc.). Comentários e a maioria dos `show_message`/`draw_text` também em pt-br.
- **Prefixos**: `obj_` (objetos), `scr_` (scripts), `spr_` (sprites), `snd_` (sons), `fnt_` (fontes), `rm_`/`Room` (rooms), `sq_` (sequences), `sd_` (shaders).
- **ds_grid para estado 2D**: inventário, texto de diálogo.
- **Leitura de notas** (`notes/`) antes de mexer em sistemas documentados — lá tem intenção do autor e bugs conhecidos.
- **Não rodar GameMaker pelo Claude**: build/run exige a IDE. Edite os `.gml`/`.yy`; a IDE recarrega.

## Globais Importantes (`funcoes_globais/funcoes_globais.gml`)

### Estado do jogo
- `global.pause` — bloqueia o input do Sdash (movimento/ataque).
- `global.pause_por_inventario` — diferencia o pause do menu de pause do pause por inventário.
- `global.dialogo_acontecendo` — bloqueia input de diálogo novo.
- `global.modo_construcao` — flag de construção (craft).
- `global.lingua` — `"pt-br"` ou `"en"`.
- `global.controle` — índice do gamepad conectado (auto-detectado em `obj_controle_hud`).
- `global.save` — slot de save (placeholder).
- `global.tutorial` — bool, tutorial já exibido?

### Progresso / moralidade
- **Flags de área**: `global.area_1`..`area_6` (booleanos).
- **Moralidade**: `global.maldade`, `global.bondade`, `global.honestidade`, `global.egoismo`.
- **Reputação**: `global.fama`, `global.temido`, `global.respeito`.
- **Relacionamentos**: `global.caridade`, `global.lealdade`, `global.rancor`.
- **Impacto no mundo**: `global.caos`, `global.ordem`, `global.riqueza`.
- **Personagem**: `global.arrogancia`, `global.empatia`, `global.ambicao`.

### Contadores
- `global.inimigos_mortos`, `global.minions_mortos`, `global.cabalos_alimentados`, `global.moedas`, `global.orbs`.

### Magias
- `global.tem_magia = array_create(5, false)` — 0:fogo, 1:água, 2:raio, 3:planta, 4:shooter.
- `global.magia_selecionada` — slot ativo.

### Itens / Inventário (ver Sistema de Inventário)
- `global.itens` — `ds_list` com todos os itens (constructors `cria_item`).
- `global.inventario_slots` — `ds_grid 8x4` com `{id, quantity}` por slot.
- `global.item_player` — item armado (no slot de equipamento, canto inferior direito).
- `global.item_mouse` — item sendo arrastado pelo mouse (split/troca).
- `global.menu_construcao` — `LISTA_CONSTRUCAO.{fechado, forge, agro}`.
- `global.itens_construcao` — array `[ [], [_forge], [_agro] ]`.

### Insígnias
- `global.insignias` — array com 5 `Insignia` constructors.
- `global.insignias_adquiridas` — `ds_list` de insígnias escolhidas.
- `global.reputacao`, `global.mod_dano_risco`, `global.mod_preco`, `global.chance_presente`.

### Save/Load
- `global.salva_jogo = function()` — escreve `save.json` com posição, vida, inventário, item equipado, moedas, inimigos mortos.
- `global.carrega_jogo = function()` — lê `save.json`, restaura, faz `room_goto` via `obj_transition`.

---

# SISTEMAS

## 1. Sistema de Inventário

**Objetos**: `obj_inventario`, `obj_item` (item dropado no chão), `obj_drop` (recurso de bloco quebrado).  
**Scripts**: `scripts/funcoes_itens/funcoes_itens.gml`, `scripts/scripts_construcao/scripts_construcao.gml`.  
**Globais**: `global.inventario_slots` (ds_grid 8x4), `global.itens` (ds_list), `global.item_player`, `global.item_mouse`.  
**Enums**: `ITENS`, `TIPO_ITENS` (consumivel/material/armamento), `LISTA_CONSTRUCAO`, `LISTA_FORGE`.  
**Notas**: `notes/inventario/inventario.txt`.

### Slots

A grid 8x4 (`ds_grid_create(8, 4)`) armazena `{id, quantity}` por slot ou `0`/`noone` para vazio. Itens com `max_stack > 1` (materiais = 64, consumíveis como tomate/trigo = 6) são stackáveis; armamentos têm `max_stack = 1`.

### Constructor `cria_item`

Campos: `id, nome, desc, spr, frames, dano, cura, atributo, rar, vel, tipo, max_stack`. Métodos:
- `usa_item()` — equip armament OU consome consumível (sobrescrito por item: `_reia` causa 1 dano, `_cura` cura 4, `_pocao_geleia` cura 10, etc.).
- `usa_arma()` — executa a animação de ataque da arma (espinhos/arco/cajado) ou decai a invisibilidade do Sdash e toca `sq_ataque_especial_sdash1`.

### Funções principais (em `funcoes_itens.gml`)

- `adiciona_ao_inventario(_item_id, _qtd)` — stacka em slots existentes (se stackável) e cai pra slot vazio. Retorna `false` se inventário cheio.
- `procura_item_inventario(_id_item)` — soma `quantity` de todos os slots com aquele id.
- `tem_materiais(_estrutura)` — checa se a receita cabe.
- `consome_materiais(_estrutura)` — deduz qtd stack a stack; remove slot se zerar.

### Controle

- **Abrir/fechar**: tecla `E` ou `gp_face4` (gamepad) — `obj_inventario` Step.
- **Drag/split**: botão esquerdo troca com `global.item_mouse`; botão direito split pilha (se `max_stack > 1`) OU equipa armamento OU consome consumível.
- **Equipamento**: slot 32x32 no canto inferior direito (1000,564) — renderiza `global.item_player`. Botão direito desequipa (devolve ao inventário com stack check).
- **Drop**: tecla `D` num slot — cria `obj_drop` na posição do Sdash com `meu_id`/`sprite_index`/`image_index`/`qtd` do item, e esvazia o slot.
- **Itens de chão**: `obj_item` (estrutura `cria_item` específica) — colisão com Sdash chama `item.coleta_item()`. Já `obj_drop` (recurso de bloco quebrado) tem física leve: cai com gravidade, oscila, e ao tocar Sdash soma ao inventário; drops do mesmo `meu_id` se fundem após `alarm[0]=60` ativa `posso_destruir=true`.

### Menu de Construção (CRAFT)

Aberto dentro do inventário (quando `global.modo_construcao` ativo). Usa `enum LISTA_CONSTRUCAO` (fechado/forge/agro) e `enum LISTA_FORGE` (fornalha/mesa/bigorna/extrator).

Constructors em `scripts_construcao.gml`:
- `cria_materiais([item_ids], [qtds])` — `item[]`, `qtd[]`.
- `cria_estrutura(nome, desc, materiais)` — `desenha_info(x, y)` mostra os materiais com cores verde/verde-claro conforme tenha ou não.

Receitas prontas: Fornalha (10 pedra + 5 madeira), Mesa (5 madeira), Bigorna (3 bloco_pedra + 4 madeira), Extrator (3 bloco_pedra).

Fluxo de craft (em `obj_inventario` `desenha_itens_construcao`):
1. Mouse sobre botão de estrutura → fica ciano.
2. Se `tem_materiais` true + clique → `consome_materiais` + `instance_create_layer` de `obj_place` + brilho.
3. `inventario = false` fecha o menu.

---

## 2. Sistema de Diálogo

**Objetos**: `obj_dialogo`, `obj_par_npc` (parent de todos os NPCs).  
**Scripts**: `scripts/scripts_textos/scripts_textos.gml`, `scripts/scripts_textos_en/scripts_textos_en.gml`.  
**Globais**: `global.dialogo_acontecendo`, `global.lingua`.  
**Notas**: `notes/sistema de dialogo/sistema de dialogo.txt`.

### Fluxo

1. Sdash entra em colisão (`distance_to_object(obj_par_npc) <= 15`) e pressiona `F` (ou `gp_face2`).
2. Cria `obj_dialogo` com `_dialogo.npc_nome = _npc.nome` e `_dialogo.npc_ref = _npc`.
3. `obj_dialogo` Create define `texto_grid` (ds_grid 4xN) vazia, e Step chama `script_execute(scr_textos)` (ou `_en` se `global.lingua != "pt-br"`).
4. `scr_textos`/`scr_textos_en` é um `switch (npc_nome)` que chama `ds_grid_add_text(texto, retrato, lado, nome)` e opcionalmente `add_op(texto_opcao, caso_destino)`.
5. Step parseia a primeira página, separando palavras e efeitos inline.
6. Alarm[0] avança 1 caractere a cada tick (15 ticks em pontuação).
7. Tecla `Space`/`gp_face1` pula para a próxima página (ou para o fim).
8. Na última página sem opções, `Space`/`Enter` fecha o diálogo: `npc_ref.terminou_dialogo = true` + `instance_destroy()` + `global.pause = false` + `global.dialogo_acontecendo = false`.

### Estrutura `texto_grid` (4 colunas)

```
enum Infosnpc { Texto, Retrato, Lado, Nome }
```

- `Texto` — string com tags inline de efeito.
- `Retrato` — sprite do portrait.
- `Lado` — `0` (esquerda) ou `1` (direita); muda a posição da caixa.
- `Nome` — string exibida acima do diálogo.

### Tags inline de efeito

Parser custom em `obj_dialogo` Step (linha ~30-76). Tags suportadas:
- `[tremor]...[/tremor]`, `[bounce]...[/bounce]`, `[pulsar]...[/pulsar]`, `[onda]...[/onda]`, `[abalo]...[/abalo]`, `[flutuar]...[/flutuar]`, `[zoom]...[/zoom]`, `[semefeito]`
- `[cor=vermelho]...[/cor]` (vermelho, azul, amarelo, roxo, laranja, verde)

Efeitos renderizados em `draw_text_effect(_x, _y, _texto, _sep, _width, _palavras, _efeitos)` — palavra-por-palavra com `sin(current_time * X)` para pulsar/onda/zoom, `random_range` para tremor/abalo, e cor custom.

### Opções (perguntas/respostas)

`add_op(texto, caso_destino)` empilha em `opcao[]` e `opcao_resposta[]`. Quando chega ao fim da última página E `opcao_numero > 0`, mostra o menu de opções com `spr_bg_opcoes` + `spr_seletor_opcoes` e setas W/S. `Enter`/`gp_face1` cria um novo `obj_dialogo` com `npc_nome = opcao_resposta[selecionado]` — ou seja, o `case` correspondente do switch.

### Helpers globais (no fim de `scripts_textos.gml`)

- `ds_grid_add_row()` — expande a grid em 1 linha.
- `ds_grid_add_text(texto, retrato, lado, nome)` — adiciona uma página.
- `add_op(texto, destino)` — adiciona opção.
- `draw_text_effect(...)` — renderiza o texto com efeitos.

---

## 3. Sdash (Player)

**Objeto**: `obj_sdash`.  
**Scripts**: `scripts/scripts_do_sdash/scripts_do_sdash.gml` (estados).  
**Notas**: `notes/Note3/Note3.txt` (enredo).

### Variáveis principais (Create)

- Vida: `vida`, `max_vida = 10`. Estamina: `estamina`, `max_estamina = 120`.
- Estado: `estado = scr_sdash_correndo`. Máquina de estados: `scr_sdash_correndo`, `scr_sdash_dash`, `scr_sdash_atacando`, `scr_sdash_hit`, `scr_sdash_arco`, `scr_sdash_cajado`.
- Direção: `dir` (0=direita, 1=cima, 2=esquerda, 3=baixo).
- Velocidade: `veloc = 2`. Dash: `dash_veloc = 6`.
- Movimentação: `hveloc`, `vveloc`.
- Inventário: `ferramenta`, `ferramenta_selecionada` (picareta), `global.item_player` (arma).
- Combate: `dano = 1`, `tomardano = true`, `empurrar_dir/veloc`, `inimigos_atingidos` (ds_list), `atacar`, `dano_alfa` (piscada ao tomar dano).
- Cavalo: `montado`, `meu_cavalo`.
- Audio: `audio_listener_position(x, y, 0)` toda frame (Sdash é o "ouvinte").
- Transição: `fade_alpha`, `fade_estado` (0=ocioso, 1=fechando, 2=abrindo), `target_sala/x/y`.

### Controles

- **Movimento**: `WASD` ou analógico esquerdo. Deadzone 0.25.
- **Dash**: `botão direito mouse` ou `gp_shoulderr` — consome 10 de estamina, dura 8 frames, deixa invencível (`tomardano = false`).
- **Atk melee (soco)**: `clique esquerdo` ou `gp_face3` quando sem ferramenta/arma equipada. Troca sprite para `spr_sdash_atacando_*` e usa hitbox própria. Aplica `obj_sdash.dano` a `obj_par_inimigos`/`obj_par_boss` via `instance_place_list`. Cria `obj_dano_highlight` e `scr_screen_shake(15, 5)`.
- **Atk com arma equipada**: chama `global.item_player.usa_arma()` — anima via `sq_ataque_especial_sdash1`, esconde Sdash, e.g. espada/arco.
- **Ferramenta (picareta)**: `C` ou `gp_shoulderlb` alterna entre ferramenta e arma. Picareta quebra `obj_mineravel` (rochas/árvores) via `meu_seletor.alvo` quando está perto. Cria `obj_drop` no chão.
- **Magia**: `Z` (lookup em `global.magia_selecionada`). 0=fogo (`obj_bola_de_fogo` em espiral), 1=água (`create_particle_effect("rain")` 200 frames c/ 1000 partículas), 2=raio, 3=planta, 4=shooter.
- **Inventário**: `E`/`gp_face4`. (Gerenciado por `obj_inventario`.)
- **Diálogo**: `F`/`gp_face2` quando perto de `obj_par_npc`.
- **Montar cavalo**: `R` em cima de `obj_cavalos`. Bloqueia movimento até desmontar.
- **Pular intro / Lootbox**: `O` cria `obj_lootbox` (debug).

### Máquina de estados

`scr_sdash_correndo` (Step principal) — chama `scr_sdash_colisao()` (axis-by-axis collision com `obj_parede`). Detecta entrada de dash/ataque e troca `estado`.

`scr_sdash_dash` (Alarm[0]=8) — `tomardano=false`, move a `dash_veloc=6` na direção travada, spawna `obj_dash` para efeito visual. Alarm[0] expira → volta a `scr_sdash_correndo`.

`scr_sdash_atacando` — `instance_place_list` contra `obj_par_inimigos`, deduz dano, marca `hit=true`, `empurrar_dir/veloc=6`, `estado = scr_art_hit`, alarm[1]=5. Quando a animação acaba (`fim_da_animacao()`) volta a correr.

`scr_sdash_hit` — knockback enquanto `alarm[2]>0`.

`scr_sdash_arco` / `scr_sdash_cajado` — estados específicos de arma (soltar clique solta projétil `obj_flecha` ou `obj_magia_lv1`).

### Morte

`vida <= 0` → spd=-2, gira, `instance_destroy()`, `room_goto(Room_game_over)`, `active=false`.

### Empurrar bloco

`obj_bloco_movel` é empurrado pelo Sdash se a frente estiver livre (`place_meeting` com `obj_parede`).

---

## 4. Sistema de Câmera

**Objeto**: `camera_sdash` (persistente).  
**Script**: `scripts/scripts_screen_shake/scripts_screen_shake.gml`, `funcoes_globais` (resetar_camera, setar_camera).  
**Globais implícitos**: `obj_sdash` (alvo), `obj_transition` (foco em transições).

### Funcionalidades (Step)

- **Seguir Sdash** com `lerp` (velocidade `vel_lerp_cam = 0.05`).
- **Olhar adiante**: `Shift + mouse` puxa a câmera até `offset_max = 60` pixels na direção do cursor.
- **Zoom**: `Shift + scroll` ajusta `cam_w_alvo` em passos de `zoom_step = 64`, clamp `[zoom_min=300, zoom_max=480]`. Ratio aspect mantido.
- **Screen shake**: `scr_screen_shake(forca, tempo)` seta `shake_forca`, agenda `alarm[0] = tempo` para resetar. Em Step, adiciona `random_range(-shake_forca, shake_forca)` antes de aplicar posição.
- **Aplicar tamanho**: `camera_set_view_size(cam, cam_w_atual, cam_h_atual)` (cam = `view_camera[0]`).

### Helpers (em `funcoes_globais.gml`)

- `resetar_camera(_vel=0.05)` — fixa em 334x192 (estilo "zoom out").
- `setar_camera(_vel=0.05)` — fixa em 509x288 (zoom in default).

---

## 5. Sistema de Transição

**Objeto**: `obj_transition` (também `obj_transicao` antigo) e `obj_sdash` tem fade interno.

### `obj_transition`

Create: `alpha=0`, `fade_in=true`, `target_room`, `target_x`, `target_y`, `fade_speed=0.05`.  
Step: se `fade_in` soma `alpha`; ao chegar a 1, `room_goto(target_room)`, posiciona Sdash, e vira `fade_in=false`. Decresce alpha; ao chegar a 0, `instance_destroy()`.  
Draw GUI: retângulo preto com `alpha` atual.

### `obj_sdash` (fade inline)

`fade_estado=0` (ocioso) → ao colidir com `obj_transicao`, vira `fade_estado=1`. Step adiciona `fade_vel=0.03` ao `fade_alpha`; ao chegar a 1, `room_goto(target_sala)`, posiciona x/y, vai para estado 2. Decresce alpha. Draw GUI desenha retângulo.

### Save/Load via transição

`global.carrega_jogo` cria `obj_transition` com `target_room`/`target_x`/`target_y` salvos.

---

## 6. Sistema de Missões

**Objetos**: `obj_controler_missao1/2/3`, `obj_misson_manager`, `obj_tutorial`.  
**Scripts**: `scripts/scripts_missoes/`, `scripts_m_database/`, `scripts_m_iniciar/`, `scripts_m_pegar/`, `scripts_m_manager/`.  
**Globais**: `global.missoes[]` (array), `global.missao1_terminou`, `global.missao_em_cutscene`.

### Estrutura de Missão (planejada em `scr_missao_teste`)

```gml
{
    id_m: "teste",
    nome: "Missão de Teste",
    status: "bloqueada" | "ativa" | "completa",
    // campos opcionais (comentados em scr_missao001): objetivos[], recompensas[],
    // npc_responsavel, gatilho_inicio/fim, cutscene_inicio/fim, ao_iniciar, ao_ficar_pronta, ao_concluir
}
```

### Funções

- `scr_missoes_banco()` — retorna array com missões definidas (atualmente só `scr_missao_teste()`).
- `scr_missoes_pegar(id)` — busca por `id_m` em `global.missoes`. Retorna struct ou `noone`.
- `scr_missoes_iniciar(id)` — seta `status = "ativa"`.

### Controllers de missão

Exemplo `obj_controler_missao1`:
- Create: `missao_comecou = true`, `global.missao1_terminou = false`, `seq_criada = false`, `sq_element = noone`.
- Step: cria sequence `sq_sdash_almudeao` na layer "sequences" usando `layer_sequence_create`. Usa `sequence_instance_override_object` para injetar `obj_sdash` real. Quando `global.missao1_terminou == true`, `layer_sequence_destroy` e `instance_destroy`.

### `obj_misson_manager` (geral, colocado no `Room_logo`)

Provavelmente inicializa o array `global.missoes` na primeira frame.

### Enredo (resumo de `notes/Note3/Note3.txt`)

35 missões planejadas. Marcos:
- **M1-M3**: Encontro com Almudeão, ida a Cubic-Land.
- **M5-M11**: Quebra de blocos, picareta, masmorra, livro mágico.
- **M13-M17**: Infernos-Land, magia de fogo, despetrificar aldeões, 6 pergaminhos.
- **M20-M22**: Coletar 10 artefatos + 10 peças pra construir a nave.
- **M23-M27**: Purpletrix, castelo, batalha final contra Reia.
- **M28-M35**: Reviravolta — Geocraft revelado, Almudeão vira inimigo, sela a barreira entre Purpletrix e Geoearth.

---

## 7. Sistema de Batalha

**Objetos**: `obj_parametros_batalha`, `obj_arena_batalha`, `obj_pai_boss_battle`, `obj_botao_controller`, `obj_minigame_ataque`, `obj_boss_andrius`, `obj_boss_andrius_projetil`, `obj_boss_andrius_ataque_2`, `obj_minion_andrius_1`, `obj_numeros`, `obj_teste_monstro`.  
**Scripts**: `scripts/scripts_do_boss/scripts_do_boss.gml` (ataques do Andrius), `scripts/script_ataques_dos_inimigos/`, `scripts/scripts_do_art/scripts_do_art.gml` (scr_art_colisao, scr_art_checar_sdash, scr_art_hit).  
**Folder dedicado**: `folders/Batalha em turno/`.

### Modos

- **Combate corpo-a-corpo** (top-down normal, fora de arena): colisão `obj_sdash_hitbox` × `obj_par_inimigos`/`obj_par_boss` aplica dano, knockback, screen shake. Scripts do boss controlam projéteis/minions.
- **Batalha em turno** (entrando em `Room_batalha_padrao`): `obj_parametros_batalha` Create define:
  - Arena: `global.borda_largura_arena = 640`, `global.borda_altura_arena = 200`.
  - Sdash: `global.vida_arena_sdash = 20`, `global.velocidade_arena_sdash = 4`, `global.invframes = 0`.
  - Turnos: `global.turno = 0` (jogador) ou `1` (inimigo). `global.comeca_batalha = true`.
  - Inimigo: `global.inimigo = array_create(1, noone)` e instancia `obj_teste_monstro` no centro.
  - UI: `global.batalha_menu` (-1 = fechado, 0 = aberto), `global.ui_selecao_menu = 0`.
  - Itens: `global.item_batalha[] = ["Chapeu", "Elixir", "Graveto", "Pistola"]`.
  - `global.pode_fugir = true`.

### Minigame de Ataque (`obj_minigame_ataque`)

Barra de timing para acertar ataque:
- `barra_pos` (0..600) se move a `barra_speed=5`.
- `hit_zone = 300` (centro), `hit_window = 50` (tolerância).
- `dano_base = 10`. Dano real = `dano_base * (1 - dist/hit_window)` se dentro da janela, senão 0.
- `Space` calcula o dano, aplica em `global.inimigo[0]`, dispara diálogo `sdash_atacar` e troca turno.

### Boss Andrius (`obj_pai_boss_battle` + `obj_boss_andrius`)

- `obj_pai_boss_battle` Create: `nome_boss`, `vida/vida_max=100`, `fase_ataque` (0/1/2), `ataque_timer=0`, `image_speed=0.2`.
- Step: se `global.turno == 1 && !obj_dialogo`, a cada 60 frames chama `scr_ataques_boss(nome, ataque_id, fase, timer)`. Ao morrer, volta pra room anterior.
- `scripts_do_boss.gml`:
  - `scr_boss_escolher_ataque()` — sorteia entre 4 ataques.
  - `scr_boss_ataque1` — "bonequinho GD" — minions circulares (2-6) + projéteis radiais 12x.
  - `scr_boss_ataque2` — "minions felipitos" — só minions circulares.
  - `scr_boss_ataque3` — "bomba fragmentada" — minions + 4 fragmentos aleatórios.
  - `scr_boss_ataque4` — "ataque numérico" — minions + 8 notas numéricas coloridas.
- HUD do boss: `obj_controle_hud` Draw 64 — desenha `spr_boss_hud` + barra de vida escalável.

### Inimigos (`obj_par_inimigos`)

Padrão de script de inimigo (`scripts_do_art.gml`):
- `scr_art_colisao()` — colisão com `obj_parede` axis-by-axis.
- `scr_art_checar_sdash()` — se `distance_to_object(obj_sdash) <= dist_aggro`, vira `scr_art_perseguindo`.
- `scr_art_hit` — knockback com `empurrar_dir/veloc` durante `alarm[1]`.

Colisão de `obj_sdash_hitbox` (helper de hitbox do Sdash) — gera o dano, knockback, screen shake, número flutuante.

---

## 8. Sistema de Magias

**Slot circular**: `obj_slot_magia` — 5 slots em raio (`raio=30`) ao redor do centro da GUI. `num_slots=5`.  
**Magia fogo**: `obj_bola_de_fogo` — espiral de Archimedes (varia `t` e `r` por step). `life=90` frames, `dano_impacto=1`, `queima_dps=1` por `queima_tick=1` durante `queima_dur=120` frames.  
**Magia água (Z, magia=1)**: chama `create_particle_effect(x, y-800, "rain", 200, c_white, 10, 360, 2, 1000)` no Sdash — chuva de partículas por 200 frames.  
**Magia raio/planto/shooter**: referenciadas em switch (`global.magia_selecionada`) mas majoritariamente stub.  
**Helper partículas**: `create_particle_effect(_x, _y, _type, _duration, _color, _size, _direction, _speed, _count)` em `funcoes_globais.gml` — `obj_part` é a instância; tipos: "explosion", "trail", "rain", "spark".  
**Projéteis de cajado**: `obj_magia_lv1` — segue reto, e se entrar em 50px de `obj_par_inimigos` faz `lerp(direction, angulo_alvo, 0.025)` (homing suave). Colisão com `obj_par_inimigos` aplica 5 de dano.

---

## 9. Sistema de Craft / Construção

Ver **Sistema de Inventário → Menu de Construção** (acima).  
Constructors `cria_materiais`, `cria_estrutura` em `scripts_construcao.gml`. Estado `global.menu_construcao`, `global.itens_construcao`.

---

## 10. Sistema de HUD

**Objeto**: `obj_controle_hud`.  
**Script**: implícito.

### Step

Detecta gamepads conectados e seta `global.controle = i` (primeiro conectado).

### Draw 64 (só se `obj_sdash.active`)

- **Barra de vida**: `spr_hud_barra_vida` escalada por `vida/max_vida`.
- **Barra de estamina**: `spr_hud_barra_estamina` escalada por `estamina/max_estamina`.
- **Moldura**: `spr_hud_vida` 3x.
- **Moedas**: `spr_moeda` no canto + texto com `global.moedas`.
- **Boss HUD**: se `obj_boss_andrius` existe e `comecou_luta`, `spr_boss_hud` centralizado com `spr_boss_vida` escalada.

### Gamepad auto-detect

`for (i=0; i<gamepad_get_device_count(); i++) if (gamepad_is_connected(i)) global.controle = i`.

---

## 11. Sistema de Dia/Noite

**Objeto**: `obj_dia_noite`.  
Usa uma `surface` (recriada se não existe). Step:
- `momento = (sin(.2 * get_timer() / 1000000) + 1) / 2` — onda suave 0..1.
- Desenha retângulo `c_black` com alpha = `min(momento, 0.75)`.
- Onde tem `obj_luz` (poste/lanterna), usa `gpu_set_blendmode(bm_subtract)` para "furar" o escuro com 3 círculos de alpha decrescente (0.8, 0.5, 0.3), resetando o blend no fim.
- `draw_surface(surf, 0, 0)` aplica a iluminação sobre a room.

---

## 12. Sistema de Pause

**Objeto**: `obj_pause`.  
**Global**: `global.pause_menu = {active, selected, options:["Continuar", "Menu Principal"]}`.

### Step

- **Tecla `Esc`** alterna `global.pause_menu.active`. Pausa áudio quando ativa, resume quando desativa.
- **Setas cima/baixo**: navega `selected` em `[0, 1]`.
- **Enter**: opção 0 (Continuar) despausa; opção 1 (Menu Principal) vai pra `room_menu`.
- **Sdash morre**: `instance_destroy()`.

### Draw 64

- Fundo gradiente entre `#1A2029` e `#1A2304`/`#660066` com `bg_alpha` (0..0.6).
- Título "PAUSADO" com sombra + verde neon `#00CC99`.
- Lista de opções com sublinhado animado na selecionada.

---

## 13. Sistema de Save/Load

**Implementação inline** (não tem objeto dedicado) — `obj_data` Create define `global.salva_jogo` e `global.carrega_jogo` como funções.  
**Arquivo**: `save.json` no diretório do jogo.

### Save (`global.salva_jogo`)

Serializa `obj_sdash` (x, y, room, vida, max_vida, item, inimigos_mortos, moedas) + `global.inventario_slots` para JSON, escreve com `file_text_open_write` + `file_text_write_string`.

### Load (`global.carrega_jogo`)

- Se `!file_exists("save.json")` → aborta com `show_debug_message`.
- Lê com `file_text_open_read` + `file_text_read_string` + `json_parse`.
- Cria `obj_sdash` se não existir, aplica vida/max_vida/active/escala.
- Cria `obj_transition` com `target_room/x/y` salvos.

**Bugs conhecidos**: a versão original do load (comentada no Create) sobrescreve `x/y` depois de `room_goto` mas perde consistência; a versão atual usa transição. Recomenda-se revisar.

---

## 14. Sistema de Diálogo de Boas-Vindas (Tutorial)

**Objeto**: `obj_tutorial`.  
Step: se `instance_exists(obj_sdash) && !global.tutorial` → cria `obj_dialogo` com `npc_nome = "boas_vindas"` e `instance_destroy()`.

---

## 15. Sistema de Minimap

**Objeto**: `obj_minimap`.  
**Create**: `minimap_w=400, minimap_h=300`, posicionado no canto inferior direito (`minimap_x/y`), `scale = min(w/room_w, h/room_h)`, `alpha=0.6`.  
**Draw 64**: desenha fundo preto, itera `layer_get_all()` desenhando tilemaps como retângulos cinza (#A0A0A0) e depois `with (all)` desenhando sprites visíveis com `0.6 * scale` e `alpha=0.6`. Útil para o player se localizar em rooms grandes.

---

## 16. Sistema de Skill Tree

**Objetos**: `obj_skill_tree`, `obj_skill_tree_pag_2`, `obj_skill`.  
**Sala dedicada**: `Room_skill_tree`, `Room_skill_tree_pag_2`.  
**Slot Mágico** (relacionado): `obj_slot_magia` — 5 slots em raio `30` ao redor do centro da GUI, com `escala`/`escala_alvo` para animação de hover (padrão `lerp` no Step do slot).

---

## 17. Sistema de Lojas

**Objetos**: `obj_loja`, `obj_loja_casinha`, `obj_shop_int_1`.  
**Folder**: `folders/Objetos/Configurações/Inventario/` (parte).  
**Mecânica**: usa `global.mod_preco` (modificado por insígnia de Fama) e `global.moedas`.

---

## 18. Sistema de Lootbox / Insígnias

**Objetos**: `obj_lootbox` (baú), `obj_loja_casinha` (lugar onde aparece).  
**Script**: `scripts/scripts_lootbox/scr_lootbox.gml` (em `scripts/`).  
**Globais**: `global.insignias[]` (5 constructors `Insignia`), `global.insignias_adquiridas` (ds_list), `global.reputacao`, `global.mod_dano_risco`, `global.mod_preco`, `global.chance_presente`.  
**Enum**: `INSIGNIA_TIPO { honra, coragem, fama, sombra, amizade }`.

### Fluxo

1. `obj_lootbox` Create: sorteia 3 insígnias únicas (de `global.insignias`), `estrelas_total = irandom_range(2, 5)`, `estrelas_reveladas = 0`, `timer_revelacao = 0`, `escolha_feita = false`.
2. Step: revela 1 estrela a cada `(35 + estrelas_reveladas * 25)` frames. Quando todas reveladas, permite clicar em um dos 3 slots.
3. Clique → `aplicar_insignia(escolhida)` → efeito conforme `tipo`:
   - `honra` → `reputacao += valor`.
   - `coragem` → `mod_dano_risco += valor`.
   - `fama` → `mod_preco *= (1 - valor)`.
   - `sombra` → `mod_dano_risco += valor*0.5`, `reputacao -= valor*0.8`.
   - `amizade` → `chance_presente += valor`.
4. Efeito visual: `obj_sdash.cor_brilho` e `tempo_brilho=180` (3s).

---

## 19. Sistema de Jukebox / Minigame Musical

**Objeto**: `obj_jukebox`.  
**Global**: `global.jukebox_sintonizada`.

### Minigame

- Abre com `F` quando `distance_to_object(obj_sdash) <= dist_interacao = 24`.
- 3 espirais. Cada uma tem: `nota_frame[i] = irandom(4)`, `nota_ang[i] = random_range(0, 360)`, `nota_dist[i] = random_range(18, 30)`.
- Ponteiro gira a `ponteiro_vel[espiral_atual]` (2/4/8 graus/step).
- `Space` → calcula `erro = angle_difference(ang_real, nota_ang[i])`.
  - `|erro| <= erro_permitido[i]` (20/15/12) → ACERTO, próxima espiral.
  - `|erro| <= erro_permitido + 15` → QUASE ACERTO, cooldown 0.5s.
  - else → ERRO, cooldown 1s.
- Se completar 3 → `global.jukebox_sintonizada = true` + animação de toca-disco (`toca_estado` 1→2→3→4: aparece, disco entra, agulha desce, disco gira `disco_ang += 0.6`).
- Áudio espacial: `audio_emitter_create` + `audio_play_sound_on(snd_summer)` com `audio_falloff_set_model(audio_falloff_exponent_distance)`.

---

## 20. Sistema de NPCs Procedurais

**Objeto**: `obj_npc_proc` (e `obj_npc_spawner` para spawnar).  
**Scripts**: `scripts/npc_defs/`, `scripts/npc_database/`, `scripts/npc_move_with_collision/`.  
**Enums**: `NPC_ROLE { CIVIL, MERCHANT, GUARD }`, `NPC_STATE { IDLE, WALK, TALK, FLEE }`.

### Geração (Create)

- Necessidades aleatórias: `need_social`, `need_rest`, `need_wander` em [30..100].
- Personalidade: `bravery`, `sociable` em [20..80].
- Identidade: `npc_id = irandom(999999)`, `role = choose(NPC_ROLE...)`.
- Aparência procedural: `body_sprite = spr_npc_body_0`, `body_frame = irandom(...)`, e mesmo para `hair_sprite`/`cloth_sprite`.
- Estado inicial: `state = NPC_STATE.IDLE`.
- Movimento: `speed_walk = 0.5`, `target_x/y = x/y`, `wait_time = irandom_range(60, 200)`.
- `image_xscale = choose(-1, 1)`, `image_yscale = choose(-1, 1)`.
- `flee_from = noone`.

### Spawner

`obj_npc_spawner` Create: `spawn_max = 16`, `radius = 160`.

### Movimento com colisão

`npc_move_with_collision(_hspeed, _vspeed)` em `npc_move_with_collision.gml` — testa `place_meeting` axis-by-axis contra `obj_parede`.

---

## 21. Sistema de Save Point / Transição de Mapa

**Objeto**: `obj_save` (interagir para salvar).  
**Comportamento**: ao tocar Sdash, chama `global.salva_jogo()`. `Destroy_0` apenas confirma estado.

---

## 22. Sistema de Cutscenes

**Sequences**: `sq_almudeao_apresentacao`, `sq_andrius_abertura`, `sq_andrius_defeat`, `sq_ataque_especial_sdash1`, `sq_cutscene_intro`, `sq_logo_geocomunity`, `sq_sdash_almudeao`, `sq_tutorial`.  
**Disparo**: `obj_pai_boss_battle` Step chama `scr_ataques_boss`; `obj_controler_missaoN` Step cria `layer_sequence_create("sequences", x, y, sq_...)` e usa `sequence_instance_override_object` para injetar `obj_sdash` real.  
**Helper (comentado)**: `scr_cutscene_tocar(seq)` — cria sequence na layer `"sequences"`.

---

## 23. Sistema de NPCs Fixos / Diálogo

**Objetos principais**: `obj_almudeao`, `obj_king_art`, `obj_king_art_treino`, `obj_king_art_treino_pag2`, `obj_dona_petunia`, `obj_professor_pei`, `obj_hanna`, `obj_inajara`, `obj_sir_gritado`, `obj_skill`.  
Todos são filhos de `obj_par_npc`. O `Create` define `nome = "..."` (string casada com `case` em `scr_textos`).  
`obj_almudeao` Create: `nome = "Missao Cavalos"`, `depth = -y`.  
`obj_king_art` Create (extends parent): `nome = "Segundo Texto"`, `terminou_dialogo = false`, `pos_dialogo = false`, `king_foi = false`, `sons = [snd_summer, snd_explosion, snd_dash]`.

---

## 24. Sistema de Efeitos Visuais

### `efeito_brilho` (constructor em `funcoes_globais.gml`)

`new efeito_brilho(cor, tempo)` — `alpha`, `valor = 1/tempo`, `brilho = bool`. Métodos `inicia_brilho()`, `brilhando()` (decrementa alpha), `desenha_brilho()` (usa `shader sd_brilho`). Usado em mineráveis, item drop, picareta, etc.

### Shaders

- `sd_brilho` — usado pelo `efeito_brilho` (glow aditivo).
- `sd_saturacao` — usado em `obj_sdash` Draw para realçar a sprite.
- `sd_distort` — referenciado em `obj_distort_controller`.

### Partículas

- `obj_part` (partícula genérica) — `vida`, `image_alpha`, `image_speed` controlado por switch (`explosion`, `trail`, `rain`, `spark`).
- `create_particle_effect()` em `funcoes_globais.gml` — spawna N partículas com tipo/duração/cor/tamanho/direção/velocidade.

### Outros efeitos

- `ini_boing` / `aplica_boing` / `efeito_boing` / `desenha_boing` — efeito de "bouncy" (estica/encolhe) usado em mineráveis.
- `tremer_objeto`, `piscar_objeto`, `mudar_cor_gradual`, `ajustar_escala_gradual`, `rotacionar_gradual` — todos em `funcoes_globais.gml`.
- `mover_suavemente`, `mover_ate_alvo`, `mover_suavemente`, `mover_suavemente_ate_alvo` — helpers de interpolação.
- `cria_brilho(x, y, cor)` — wrapper para `instance_create_depth` de `obj_brilho`.
- `drop_moedas(x, y, min, max)` — dropa `obj_moeda` com offset aleatório.
- `gerar_texto_flutuante(x, y, texto, cor, duracao, camada)` — spawna `obj_texto_flutuante`.

### Audio

- `scripts_sistema_audio.gml` define `audio_controle(str_sfx, str_musica, str_mestre)` constructor + `audio_elemento()`, `tocar_audio_unico()`, `tocar_audio_loop()`.
- `global.sdash_sons = [snd_ihu_intro, snd_blip_2, snd_blip_select, snd_blim]` — sample Sdash para diálogo.
- `audio_listener_position(x, y, 0)` em Sdash Step.
- `audio_play_sound` no `obj_dialogo` Alarm[0] (som por caractere, delay maior em pontuação).

### Tween

`scripts/scr_tween/scr_tween.gml`:
```gml
tween(_object, _variable_name, _value, _animation = "back", _time = room_speed, _callback = -1)
```
Usa `animcurve_get_channel(tween_curves, _animation)`. Cria `obj_tween` que faz a interpolação.

---

## 25. Sistema de Movimentação Senoidal (helper)

**Script**: `scripts/scripts_movimento_senoidal/scripts_movimento_senoidal.gml`:
```gml
scr_movimento_senoidal(centro_x, centro_y, raio, velocidade)
```
Move em círculo (cos/sen) ao redor do ponto. Usado para NPCs que pairam.

---

## 26. Sistema de Câmera (extra)

Ver seção dedicada acima (`obj camera_sdash`).

---

## 27. Sistema de Idioma (i18n)

**Objeto**: `obj_botao_idioma` (botão no menu).  
**Globais**: `global.lingua = "pt-br"`.  
Step do botão: clique alterna entre `"pt-br"` e `"en"` e atualiza o `image_index`.  
Em `obj_dialogo` Step: se `global.lingua == "pt-br"`, chama `scr_textos`; senão `scr_textos_en`. Ambas as funções têm o mesmo formato de `switch (npc_nome)`.

---

## 28. Sistema de Botões / UI (genérico)

**Objeto**: `obj_botao` (parent).  
**Create**: guarda `escala_x/escala_y` iniciais, define `acao = function() {}`.  
**Step**: `image_xscale = lerp(image_xscale, escala_x, 0.2)` (volta ao tamanho).  
Filhos definem `acao` para o que o botão faz.

### Menu principal (`obj_menu`)

Step usa `botao_texto(_x, _y, _w, _h, _id)` para hit-test de botões. `estado`/`estado_desejado` com `MENU_ESTADO` (não está aqui — procurar enum). `alpha_menu`/`escala_menu` interpolam. Tem submenus `principal`, `mundos`, `opcoes`. Em `opcoes` persiste em `config.ini` (volume, fullscreen, dificuldade).

---

## 29. Sistema de Game Over

**Objeto**: `obj_game_over_room1`.  
Step: ao colidir com Sdash (?), ações de fim de jogo. Sdash com `vida <= 0` chama `room_goto(Room_game_over)`.

---

## 30. Sistema de Transição de Mapa / Teleporte

**Objetos**: `obj_transicao` (antigo), `obj_teleporter`.  
Usado em conjunto com `obj_sdash` `Collision_obj_transicao.gml` que seta `target_sala/sdashx/sdashy` e dispara o fade.

---

## 31. Sistema de Drops de Bloco (crafting)

**Objetos**: `obj_bloco`, `obj_bloco_pedra`, `obj_bloco_madeira`, `obj_bloco_terra`, `obj_bloco_movel`, `obj_mineravel` (genérico), `obj_pedra`, `obj_drop`.  
**Scripts**: ver Sistema de Inventário.

`obj_mineravel` (Create): `vida=2`, `meu_brilho = new efeito_brilho(c_white, 60)`, gravidade (z/velz/grav=0.25), `ini_boing()`, `dropavel = "pedra"`. Step aplica `efeito_boing()` + `meu_brilho.brilhando()`. Draw desenha com `desenha_boing()` + `desenha_brilho()`. Ao perder vida → `dropa_item()` que sorteia `qtd` entre 1/2/4/8 conforme chance, e instancia `obj_drop` com `image_index` mapeando pro item.

`obj_drop` (Create): `qtd=1`, `meu_id=0`, `image_speed=0`, escala 0.5, gravidade, direção aleatória, speed=3, oscilação senoidal da escala (`osc_freq`/`osc_amp`/`osc_offset`). `alarm[0]=60` ativa `posso_destruir`. Ao tocar Sdash, `destruir=true` (fade-out). Drops do mesmo `meu_id` próximos se fundem (juntam `qtd`).

---

## 32. Sistema de Itens Colocáveis / Construção no Mundo

**Objeto**: `obj_place` (spawnado pelo craft de estruturas).  
Permite colocar a estrutura no mundo.

---

## 33. Sistema de Mini-Game (variação do "level GD")

Anotado em `notes/anotação 2/anotação 2.txt`:
- Inimigos nível 1 → corpo-a-corpo.
- Inimigos nível 2 → batalha estilo GD.
- Inimigos nível 3 → turno + bullet hell + GD.

---

## 34. Objetos de Ambiente / Decoração

- `obj_arvore`, `obj_arvore_natal`, `obj_cabana`, `obj_casa_madeira`, `obj_casa_madeira_2`, `obj_cadeira`, `obj_cama_sdash`, `obj_cerca_c`, `obj_cercah`, `obj_cercav`, `obj_capim`, `obj_capim_visual`, `obj_flor`, `obj_fornalha`, `obj_forno`, `obj_geladeira`, `obj_grama`, `obj_janela`, `obj_mesinha`, `obj_pia`, `obj_placa_bemvindo`, `obj_placa_cobre`, `obj_porta`, `obj_portao_madeira`, `obj_quadra`, `obj_vaso`, `obj_vela`, `obj_armario`, `obj_estante`, `obj_estante_quarto`, `obj_espelho`, `obj_parede`, `obj_pedra`, `obj_parede`.
- `obj_dejeto`, `obj_egg_daniel_fraga`, `obj_intro_efeito`, `obj_fonte_agua`, `obj_estatua_anjo`, `obj_igreja_templo1`, `obj_prefeitura`, `obj_quadro_prefeitos`, `obj_vrital_prefeitura` — específicos de cenários.
- `obj_chispa_pet`, `obj_cavalo_easter_egg`, `obj_cavalos` — easter eggs / pets.
- `obj_taberna`, `obj_almudeao` (versão com Andrius), `obj_farinha_xxx` — NPCs e plantas específicas.
- `obj_bola3d_effect`, `obj_transicao_circulo`, `obj_distort_controller` — efeitos especiais.

---

## 35. Sistema de Mineração / Ferramenta

- `obj_picareta` — instância única segurada pelo Sdash. Step segue Sdash e é mostrado apenas quando `ferramenta_selecionada=true`. Clicar com mouse aplica dano em `meu_seletor.alvo` (instância próxima de `obj_mineravel`).
- `obj_seletor` — marca visual o minerável alvo quando em distância ≤ 32.

---

## 36. Boss: Andrius

- `obj_boss_andrius` (boss visual), `obj_almudeao_andrius` (versão do Almudeão possuído), `obj_andrius_defeat` (cutscene de derrota), `obj_minion_andrius_1` (projéteis/minions), `obj_boss_andrius_projetil`, `obj_boss_andrius_ataque_2` (bomba fragmentada), `obj_numeros` (projéteis do ataque 4).
- A sequência `sq_andrius_abertura` e `sq_andrius_defeat` controlam as cutscenes.
- O pai `obj_pai_boss_battle` cuida do loop de turno do boss (ataca a cada 60 frames enquanto turno 1 e sem diálogo ativo).

---

## 37. Sistema de Câmera (extra - misc)

- `obj_tutorial`, `obj_submenu_extras`, `obj_submenu_mundos` — UIs auxiliares.

---

## 38. Shaders Customizados

- `sd_saturacao` — `obj_sdash` Draw seta `u_saturation=2` (saturação alta).
- `sd_brilho` — usado por `efeito_brilho` no draw com `bm_add`-like.
- `sd_distort` — `obj_distort_controller` (efeito de distorção).
- `shaders/` contém os arquivos `.yy` correspondentes.

---

## 39. Sequence Hooks (eventos)

- `sq_almudeao_apresentacao_Events116`, `sq_andrius_abertura_Events162`, `sq_andrius_defeat_Events124`, `sq_ataque_especial_sdash1_Events145`, `sq_cutscene_intro_Events119`, `sq_logo_geocomunity_Events118`, `sq_sdash_almudeao_Events159`, `sq_tutorial_Events120`, `sq_tutorial_Events123` — são os eventos GML anexados às sequences.

---

## 40. Outros Objetos Úteis

- `obj_cursor` — substituto do cursor do sistema.
- `obj_dash` — efeito visual do dash (cópia da sprite).
- `obj_flecha` (projétil do arco) e `obj_flecha_efeito` (rastro).
- `obj_tiro_revolver` — projétil de "shooter" (magia 4).
- `obj_agua_o` — efeito visual de água.
- `obj_magia_lv1` — projétil do cajado.
- `obj_bollha` (?) / `obj_ball` — bolha genérica.
- `obj_flecha_efeito` — efeito de rastro da flecha.
- `obj_elevator`, `obj_escada` — movimentação especial.
- `obj_interest_well` — ponto de interesse (decorativo).
- `obj_interruptor` — switch de alavanca.
- `obj_luz` — poste de luz (usado no dia/noite).
- `obj_text_elemento_batalha` — texto flutuante em batalha.
- `obj_chispa_pet` — mascote/spark.
- `obj_capim_visual` — grama decorativa.

---

## 41. Pastas (Resource Tree)

Organização no `Geocraft.yyp` (não mexer no `.yyp`):

- `Anotações` — notas autorais.
- `Batalha em turno` — objetos/scripts/sprites específicos de batalha.
- `Cenas` — `Iniciar`, `Introdução`, `Cubic-Land`, `centro da cidade`, `dentro da prefeitura`, `Batalhas`, `Menus`.
- `Caminhos` — paths.
- `Conjuntos de tiles` — `Cubic-Land`.
- `Curvas da animação`.
- `Fontes`.
- `Linhas do tempo` — timelines.
- `Objetos` — `Aldeias`, `cutscenes`, `Configurações` (Dialogo, Dialogos, Efeitos, Inventario, Ferramentas, Itens, Lootbox, Menu, Menus, Missoes, Sys Sdash, Hud, controles, geral, npc procedural, Uteis), `Pares` (Debug), `Personagens` (inimigos, boss, andrius, insignias, principais, npcs procedurais).
- `Particle Systems`.
- `Scribble` — biblioteca third-party.
- `Scripts` — `Configurações` (inventario/geral, inventario/Lootbox, missoes, npc, sistemas, textos, TurboGML), `Personagens` (Inimigos, scripts chefes, Sdash, sequences eventos).
- `Sprites`.

---

## 42. Notas Autorais (`notes/`)

- `notes/inventario/inventario.txt` — doc do inventário (versão antiga, 32 slots em 5 áreas; a versão atual tem 8x4 com structs).
- `notes/sistema de dialogo/sistema de dialogo.txt` — doc completa do diálogo (com `draw_text_effect`).
- `notes/Note3/Note3.txt` — enredo detalhado das 35 missões.
- `notes/Note4/Note4.txt` — pitch de marketing (indie vs AAA) + ideias de magias.
- `notes/anotação 1/anotação 1.txt` — TODO list alfa 0.03 (muitos marcados como FEITO).
- `notes/anotação 2/anotação 2.txt` — fluxo de rooms + níveis de batalha.

---

## 43. Bugs Conhecidos / TODOs (do `notes/anotação 1`)

Itens já feitos (FEITO): editor de fases, inventário, pause, diálogo, sprite de inimigos, organização, animação do primeiro boss, cutscenes, dialogo melhorado, HUD, animação do primeiro boss.  
Itens pendentes: mais "Game fell" effects, transições de room mais bonitas, melhorar câmera (F11/zoom já feito), zoom dinâmico, animações em sequences, sequence de morte, save com base 64, mais diálogos, sistema de missões com bloqueio, diálogo com respostas + portrait, consumíveis, level estilo Geometry Dash.

---

## 44. Arquivos Sensíveis (NÃO editar manualmente)

- `Geocraft.yyp` — manifest do projeto.
- `Geocraft.resource_order` — ordem de compilação.
- `options/<plataforma>/*.yy` — configurações de build.
- `folders/*.yy` — hierarquia do Resource Tree.
- `datafiles/scribble_license.txt` — licença da Scribble.
- `datafiles/ThaleahFat.ttf`, `datafiles/alagard.ttf` — fontes externas (ThaleahFat para HUD/diálogo, alagard para descrição do inventário).

---

## Referências Rápidas (cheat sheet)

| Sistema | Arquivo principal |
|---|---|
| Estado global | `scripts/funcoes_globais/funcoes_globais.gml`, `objects/obj_data/Create_0.gml` |
| Inventário | `objects/obj_inventario/*`, `scripts/funcoes_itens/funcoes_itens.gml` |
| Diálogo | `objects/obj_dialogo/*`, `scripts/scripts_textos/scripts_textos.gml` |
| Sdash (player) | `objects/obj_sdash/*`, `scripts/scripts_do_sdash/scripts_do_sdash.gml` |
| Câmera | `objects/camera_sdash/*` |
| Transição | `objects/obj_transition/*` |
| Missões | `objects/obj_controler_missaoN/*`, `scripts/scripts_m_*/` |
| Batalha em turno | `objects/obj_parametros_batalha/*`, `objects/obj_minigame_ataque/*` |
| Boss | `objects/obj_pai_boss_battle/*`, `objects/obj_boss_andrius/*`, `scripts/scripts_do_boss/scripts_do_boss.gml` |
| Magias | `objects/obj_bola_de_fogo/*`, `objects/obj_magia_lv1/*` |
| HUD | `objects/obj_controle_hud/*` |
| Dia/Noite | `objects/obj_dia_noite/*` |
| Pause | `objects/obj_pause/*` |
| Save/Load | `objects/obj_data/Create_0.gml` (funções `global.salva_jogo`/`carrega_jogo`) |
| Tutorial | `objects/obj_tutorial/*` |
| Minimap | `objects/obj_minimap/*` |
| Skill tree | `objects/obj_skill_tree/*`, `objects/obj_skill/*` |
| Lootbox/Insígnias | `objects/obj_lootbox/*`, `scripts/scripts_lootbox/scr_lootbox.gml` |
| Jukebox | `objects/obj_jukebox/*` |
| NPCs procedurais | `objects/obj_npc_proc/*`, `objects/obj_npc_spawner/*`, `scripts/npc_*/` |
| Craft | `scripts/scripts_construcao/scripts_construcao.gml` |
| Efeitos | `scripts/funcoes_globais/funcoes_globais.gml` (efeito_brilho, boing, etc.) |
| Áudio | `scripts/scripts_sistema_audio/scripts_sistema_audio.gml` |
| Tween | `scripts/scr_tween/scr_tween.gml`, `objects/obj_tween/*` |
| Menu | `objects/obj_menu/*` |
| Idioma | `objects/obj_botao_idioma/*` |
| Save point | `objects/obj_save/*` |
| Game over | `objects/obj_game_over_room1/*` |
| Drops | `objects/obj_mineravel/*`, `objects/obj_drop/*` |
| Picareta/seletor | `objects/obj_picareta/*`, `objects/obj_seletor/*` |
| Câmera shake | `scripts/scripts_screen_shake/scripts_screen_shake.gml` |
| Partículas helper | `scripts/funcoes_globais/funcoes_globais.gml` (`create_particle_effect`) |
| Movimento senoidal | `scripts/scripts_movimento_senoidal/scripts_movimento_senoidal.gml` |
