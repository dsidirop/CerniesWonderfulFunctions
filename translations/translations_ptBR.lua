local _thisLocale = "ptBR";

if CerniesWonderfulFunctions.ActiveLanguage ~= _thisLocale then
    -- only load this file if the locale matches
    return
end

CerniesWonderfulFunctions.Translations[_thisLocale] = {
    ["[DEPRECATED] "] = "[OBSOLETO] ",
    ["Function '%s()' has been deprecated - use '%s()' instead!"] = "A função '%s()' foi descontinuada - use '%s()' em vez disso!",
    ["Addon loaded. Have a look at the the readme file for instructions."] = "Add-on carregado. Dê uma olhada no arquivo readme para instruções.",
    ["Could not find the 'Start Fishing' spell in your spellbook! (did you remember to pick up the profession?)"] = "Não foi possível encontrar o feitiço 'Começar a Pescar' no seu livro de feitiços! (Você lembrou de aprender a profissão?)",

    ["** '%s' is on cooldown!"] = "** '%s' está em recarga!",
    ["** Attempting to use '%s'!"] = "** Tentando usar '%s'!",

    ["** No mage-gems found to use!"] = "** Nenhuma gema de mago encontrada para usar!",
    ["** No healthstones found to use!"] = "** Nenhuma pedra de vida encontrada para usar!",
    ["** No armor-potions found to use!"] = "** Nenhuma poção de armadura encontrada para usar!",
    ["** No health-potions found to use!"] = "** Nenhuma poção de cura encontrada para usar!",
    ["** No exotic mana-potions found to use!"] = "** Nenhuma poção de mana exótica encontrada para usar!",
    ["** No standard mana-potions found to use!"] = "** Nenhuma poção de mana padrão encontrada para usar!",
};
