local _thisLocale = "esES";

if CerniesWonderfulFunctions.ActiveLanguage ~= _thisLocale then
    -- only load this file if the locale matches
    return
end

CerniesWonderfulFunctions.Translations[_thisLocale] = {
    ["[DEPRECATED] "] = "[OBSOLETO] ",
    ["Function '%s()' has been deprecated - use '%s()' instead!"] = "¡La función '%s()' está obsoleta - usa '%s()' en su lugar!",
    ["Addon loaded. Have a look at the the readme file for instructions."] = "Add-on cargado. Echa un vistazo al archivo readme para obtener instrucciones.",
    ["Could not find the 'Start Fishing' spell in your spellbook! (did you remember to pick up the profession?)"] = "¡No se pudo encontrar el hechizo 'Comenzar a pescar' en tu libro de hechizos! (¿recordaste aprender la profesión?)",

    ["** '%s' is on cooldown!"] = "** ¡'%s' está en tiempo de reutilización!",
    ["** Attempting to use '%s'!"] = "** ¡Intentando usar '%s'!",

    ["** No mage-gems found to use!"] = "** ¡No se encontraron gemas de mago para usar!",
    ["** No healthstones found to use!"] = "** ¡No se encontraron piedras de salud para usar!",
    ["** No armor-potions found to use!"] = "** ¡No se encontraron pociones de armadura para usar!",
    ["** No health-potions found to use!"] = "** ¡No se encontraron pociones de curación para usar!",
    ["** No exotic mana-potions found to use!"] = "** ¡No se encontraron pociones de maná exóticas para usar!",
    ["** No standard mana-potions found to use!"] = "** ¡No se encontraron pociones de maná estándar para usar!",
};
