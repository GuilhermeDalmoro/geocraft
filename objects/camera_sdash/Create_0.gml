//Screen shake (balança a tela)
shake_forca = 0; //força do agito
shake_temp = 0; // tempo do efeito

cam = view_camera[0];

cam_w_atual = camera_get_view_width(cam)
cam_h_atual = camera_get_view_height(cam)

cam_w_alvo = cam_w_atual
cam_h_alvo = cam_h_atual

vel_lerp_cam = 0.05
