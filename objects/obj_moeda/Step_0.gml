image_angle++;
if (coletada) {
    // faz a moeda subir
    y += vsp;
    
    // vai diminuindo o alpha
    alpha -= 0.05;
    
    // quando ficar totalmente invisível, destrói
    if (alpha <= 0) {
        instance_destroy();
    }
}
