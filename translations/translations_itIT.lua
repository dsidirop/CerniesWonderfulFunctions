local _thisLocale = "itIT";

if CerniesWonderfulFunctions.ActiveLanguage ~= _thisLocale then
    -- only load this file if the locale matches
    return
end

CerniesWonderfulFunctions.Translations[_thisLocale] = {
    ["[DEPRECATED] "] = "[OBSOLETO] ",
    ["Function '%s()' has been deprecated - use '%s()' instead!"] = "La funzione '%s()' è obsoleta - usa invece '%s()'!",
    ["Addon loaded. Have a look at the the readme file for instructions."] = "Add-on caricato. Dai un'occhiata al file readme per le istruzioni.",
    ["Could not find the 'Start Fishing' spell in your spellbook! (did you remember to pick up the profession?)"] = "Non è stato trovato l'incantesimo 'Inizia a Pescare' nel tuo libro degli incantesimi! (Hai ricordato di imparare la professione?)",

    ["** '%s' is on cooldown!"] = "** '%s' è in tempo di recupero!",
    ["** Attempting to use '%s'!"] = "** Sto tentando di usare '%s'!",

    ["** No mage-gems found to use!"] = "** Nessuna gemma da mago trovata per l'uso!",
    ["** No healthstones found to use!"] = "** Nessuna pietra della salute trovata per l'uso!",
    ["** No armor-potions found to use!"] = "** Nessuna pozione di armatura trovata per l'uso!",
    ["** No health-potions found to use!"] = "** Nessuna pozione di cura trovata per l'uso!",
    ["** No exotic mana-potions found to use!"] = "** Nessuna pozione di mana esotica trovata per l'uso!",
    ["** No standard mana-potions found to use!"] = "** Nessuna pozione di mana standard trovata per l'uso!",
};
