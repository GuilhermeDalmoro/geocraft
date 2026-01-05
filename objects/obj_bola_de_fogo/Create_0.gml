// --- Configs básicas
sprite_index = spr_bola_de_fogo;
image_speed  = 0.3; // se for animado, senão pode ser 0

// --- Guardar ponto de origem (de onde sai a espiral)
x0 = x;
y0 = y;

// --- Direção base da espiral (por padrão, mira no mouse)
// se quiser mirar pra onde o S'Dash está olhando, troca por alguma var sua (ex: direction)
angulo_base = point_direction(x, y, mouse_x, mouse_y); // em graus

// --- Parâmetros da espiral (Archimedes vibe)
t       = 0;     // acumulador angular (graus)
vel_t   = 8;    // quantos graus por step a espiral gira (mais alto = gira mais rápido)
r       = 0;     // raio atual
dr      = 2;     // crescimento do raio por step (mais alto = espiral abre mais rápido)

// --- Vida e danos
life           = 90;  // dura ~1.5s a 60fps (ajusta à vontade)
dano_impacto   = 1;   // dano ao tocar
queima_dps     = 1;   // dano por segundo (ou por tick, ver notas abaixo)
queima_tick    = 1;  // a cada 10 frames aplica o DPS
queima_dur     = 120; // quanto tempo o inimigo fica queimando (em frames)
