// velocidade da rotação
var rot = current_time * 0.05;

// quantidade de camadas (profundidade)
var camadas = 6;

// loop criando "profundidade"
for (var i = camadas; i > 0; i--) {
    
    var offset = i * 1.5;
    
    // rotação fake
    var xx = x + lengthdir_x(offset, rot);
    var yy = y + lengthdir_y(offset, rot);
    
    // escala fake pra dar perspectiva
    var scale = 1 - (i * 0.05);
    
    draw_sprite_ext(
        sprite_index,
        image_index,
        xx,
        yy,
        scale,
        scale,
        rot, // rotação real também
        c_black,
        0.2
    );
}

// sprite principal
draw_sprite_ext(
    sprite_index,
    image_index,
    x,
    y,
    1,
    1,
    rot,
    c_white,
    1
);