global.missions = [];
global.missions[0] = {
    id: "mission_test_001",
    name: "Primeiro Confronto",
    description: "Derrotar 3 inimigos geométricos corrompidos na Room 2.",
    status: "inactive",
    objectives: ["Derrotar 3 inimigos"],
    progress: [0],
    target: 3,
    prerequisite: "", // String vazia pra nenhuma pré-requisito
    rewards: {
        gold: 50,
        gems: 1
    }
};
global.missions[1] = {
    id: "mission_grass_002",
    name: "Capim pros Cavalos",
    description: "Coletar capins e encher as caixas dos cavalos.",
    status: "inactive",
    objectives: ["Coletar capins", "Encher caixas"],
    progress: [0, 0],
    targets: [4, 4],
    prerequisite: "mission_test_001", // Só ativa após missão 1
    rewards: {
        gold: 30,
        gems: 1
    }
};
global.missions[2] = {
    id: "mission_003",
    name: "MATAR ANDRIUS",
    description: "Derrote andriusreia para prosseguir para o centro de cubic land",
    status: "inactive",
    objectives: ["Matar os minions"],
    progress: [0, 0],
    targets: [0, 0],
    prerequisite: "mission_grass_002", // Só ativa após missão 1
    rewards: {
        gold: 130,
        gems: 1
    }
};

if (!variable_global_exists("player_stats")) {
    global.player_stats = {
        gold: 0,
        gems: 0
    };
}

show_menu = false;
bg_alpha = 0; // Suaviza abertura do menu
frame_anim = 0; // Animação da moldura