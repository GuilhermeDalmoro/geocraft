// Gira e abre a espiral
t  += vel_t;
r  += dr;

// Nova posição a partir do ponto inicial, girando em torno dele
var ang = angulo_base + t; // graus
x = x0 + lengthdir_x(r, ang);
y = y0 + lengthdir_y(r, ang);

// Girinho visual da sprite, só pelo charme
image_angle += 12;

// Lifespan / fora da sala
life--;
if (life <= 0 || x < -32 || y < -32 || x > room_width + 32 || y > room_height + 32) {
    instance_destroy();
}
