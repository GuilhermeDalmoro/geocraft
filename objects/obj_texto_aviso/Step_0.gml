y -= 1; // Subindo lentamente
alpha = max(0, alpha - 0.02); // Diminui o alfa gradualmente
destroy_timer -= 1;
if (destroy_timer <= 0 || alpha <= 0) instance_destroy(); // Destroi quando acabar