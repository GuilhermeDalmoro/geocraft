/// @function scr_quest_check(quest_name)
/// @param {string} quest_name Nome da missão a verificar (ex.: "Primeiro Confronto")
/// @return {bool} Retorna true se a missão está completa, false caso contrário
function scr_quest_check(quest_name) {
    // Percorre todas as missões no array global.missions
    for (var i = 0; i < array_length(global.missions); i++) {
        // Verifica se o nome da missão atual corresponde ao parâmetro
        if (global.missions[i].name == quest_name) {
            // Retorna true se o progresso atingiu o objetivo e a missão não está ativa (ou seja, concluída)
            return global.missions[i].progress[0] >= 3 && global.missions[i].status == "completed";
        }
    }
    // Retorna false se a missão não for encontrada
    return false;
} 
