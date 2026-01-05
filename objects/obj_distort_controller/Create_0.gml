/// obj_distort_controller Create
// pega o índice do sampler do shader
distortion_stage = shader_get_sampler_index(shader_distort, "distortion_texture_page");

surface_distort = -1; // variável inicial


// parâmetros
global.distort_intensity = 1.0; // tu pode alterar em runtime
global.distort_enabled = true;

// lista de ondas (cada onda: x,y,radius,max_radius,alpha,growth_speed)
dist_waves = ds_list_create();
