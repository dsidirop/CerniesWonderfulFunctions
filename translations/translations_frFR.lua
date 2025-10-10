local _thisLocale = "frFR";

if CerniesWonderfulFunctions.ActiveLanguage ~= _thisLocale then
    -- only load this file if the locale matches
    return
end

CerniesWonderfulFunctions.Translations[_thisLocale] = {
    ["[DEPRECATED] "] = "[OBSOLÈTE] ",
    ["Function '%s()' has been deprecated - use '%s()' instead!"] = "La fonction '%s()' est obsolète - utilisez '%s()' à la place !",
    ["Addon loaded. Have a look at the the readme file for instructions."] = "Add-on chargé. Consultez le fichier readme pour les instructions.",
    ["Could not find the 'Start Fishing' spell in your spellbook! (did you remember to pick up the profession?)"] = "Impossible de trouver le sort « Commencer à pêcher » dans votre grimoire ! (avez-vous pensé à apprendre le métier ?)",

    ["** '%s' is on cooldown!"] = "** '%s' est en temps de recharge !",
    ["** Attempting to use '%s'!"] = "** Tentative d'utilisation de '%s' !",

    ["** No mage-gems found to use!"] = "** Aucun gemme de mage trouvé pour utiliser !",
    ["** No healthstones found to use!"] = "** Aucune pierre de soins trouvée pour utiliser !",
    ["** No armor-potions found to use!"] = "** Aucune potion d'armure trouvée pour utiliser !",
    ["** No health-potions found to use!"] = "** Aucune potion de soin trouvée pour utiliser !",
    ["** No exotic mana-potions found to use!"] = "** Aucune potion de mana exotique trouvée pour utiliser !",
    ["** No standard mana-potions found to use!"] = "** Aucune potion de mana standard trouvée pour utiliser !",
};
