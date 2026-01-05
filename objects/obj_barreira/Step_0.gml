if (mission_index < array_length(global.missions) && global.missions[mission_index].status == "completed") {
    instance_destroy(); // Destrói se a missão tá completa
    exit; // Sai pra não processar mais
}