// ===== INTERAÇÃO =====
ui_aberta = false;
dist_interacao = 24;

// ===== ANIMAÇÃO =====
ui_anim = 0;

// ===== MINIGAME =====
espiral_atual = 0;
total_espirais = 3;

// ponteiro
ponteiro_ang = 0;
ponteiro_vel = [2, 4, 8];

// dificuldade invisível (janela de erro)
erro_permitido = [20, 15, 12];

// notas
nota_frame = array_create(3);
nota_ang   = array_create(3);
nota_dist  = array_create(3);

// controle
pode_parar = true;
tempo_erro = 0;

// estado final
completo = false;
quase_acerto = false;

// ===== TOCA-DISCO =====
toca_estado = 0;
// 0 = desligado
// 1 = aparece
// 2 = disco entrando
// 3 = agulha descendo
// 4 = tocando

toca_x = 0;
toca_y = 0;

disco_x = 0;
disco_y = 0;
disco_alpha = 0;
disco_ang = 0;

agulha_ang = 90; // pra cima
agulha_target = 30; // descida

toca_alpha = 0;


global.jukebox_sintonizada = false;

// ===== SOM ESPACIAL =====
s_emit = audio_emitter_create();
audio_emitter_position(s_emit, x, y, 0);
audio_falloff_set_model(audio_falloff_exponent_distance);
audio_play_sound_on(s_emit, snd_summer, 1, 0);
