var _mission = global.missions[1];
if (_mission.status == "active" && array_length(_mission.progress) > 0 && _mission.progress[0] < (variable_struct_exists(_mission, "targets") ? _mission.targets[0] : 0)) {
    _mission.progress[0] += 1;
    instance_destroy();
 //   audio_play_sound(snd_pickup, 1, false); 
}