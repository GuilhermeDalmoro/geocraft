switch (estado) {
    case 0: // FADE IN
        alpha += vel_fade;
        if (alpha >= 1) {
            alpha = 1;
            estado = 1;
        }
    break;

    case 1: // SEGURA NA TELA
        timer++;
        if (timer >= tempo_visivel) {
            estado = 2;
        }
    break;

    case 2: // FADE OUT
        alpha -= vel_fade;
        if (alpha <= 0) {
            instance_destroy();
        }
    break;
}
