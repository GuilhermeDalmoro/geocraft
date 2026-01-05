// Auto-generated stubs for each available event.

function sq_ataque_especial_sdash1_Moment()
{
						// Script que você coloca no Animation End da sequence
				with (obj_sdash) {
				    active = true;
				    visible = true;
					pode_andar = true;
				}

				layer_sequence_destroy(sq_ataque_especial_sdash1); // ou layer_sequence_destroy(self);
				if (layer_exists("ataque_especial")) {
				    layer_destroy("ataque_especial");
				}
}



function sq_ataque_especial_sdash1_Moment_1()
{
	scr_sdash_atacando();
}