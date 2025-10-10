local _thisLocale = "deDE";

if CerniesWonderfulFunctions.ActiveLanguage ~= _thisLocale then
    -- only load this file if the locale matches
    return
end

CerniesWonderfulFunctions.Translations[_thisLocale] = {
    ["[DEPRECATED] "] = "[VERALTET] ",
    ["Function '%s()' has been deprecated - use '%s()' instead!"] = "Die Funktion '%s()' ist veraltet - verwende stattdessen '%s()'!",
    ["Addon loaded. Have a look at the the readme file for instructions."] = "Add-on geladen. Schau dir die Readme-Datei für Anweisungen an.",
    ["Could not find the 'Start Fishing' spell in your spellbook! (did you remember to pick up the profession?)"] = "Der Zauber 'Angeln beginnen' wurde in deinem Zauberbuch nicht gefunden! (Hast du daran gedacht, den Beruf zu erlernen?)",

    ["** '%s' is on cooldown!"] = "** '%s' ist auf Abklingzeit!",
    ["** Attempting to use '%s'!"] = "** Versuche, '%s' zu verwenden!",

    ["** No mage-gems found to use!"] = "** Keine Magier-Edelsteine zum Verwenden gefunden!",
    ["** No healthstones found to use!"] = "** Keine Gesundheitssteine zum Verwenden gefunden!",
    ["** No armor-potions found to use!"] = "** Keine Rüstungstränke zum Verwenden gefunden!",
    ["** No health-potions found to use!"] = "** Keine Heiltränke zum Verwenden gefunden!",
    ["** No exotic mana-potions found to use!"] = "** Keine exotischen Manatränke zum Verwenden gefunden!",
    ["** No standard mana-potions found to use!"] = "** Keine standard Manatränke zum Verwenden gefunden!",
};
