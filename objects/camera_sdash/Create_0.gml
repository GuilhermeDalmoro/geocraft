// Screen shake
shake_forca = 0;
shake_temp = 0;

// camera
cam = view_camera[0];

cam_w_atual = camera_get_view_width(cam);
cam_h_atual = camera_get_view_height(cam);

cam_w_alvo = cam_w_atual;
cam_h_alvo = cam_h_atual;

vel_lerp_cam = 0.05;

// ===== NOVO =====

// offset da camera (olhar adiante)
offset_x = 0;
offset_y = 0;

offset_max = 60; // distancia maxima ao puxar a camera
vel_lerp_offset = 0.1;

// zoom
zoom_step = 64; // quanto aumenta/diminui por scroll
zoom_min = 300;
zoom_max = 480;

