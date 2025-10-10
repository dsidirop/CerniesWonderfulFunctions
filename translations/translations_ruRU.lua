local _thisLocale = "ruRU";

if CerniesWonderfulFunctions.ActiveLanguage ~= _thisLocale then
    -- only load this file if the locale matches
    return
end

CerniesWonderfulFunctions.Translations[_thisLocale] = {
    ["[DEPRECATED] "] = "[УСТАРЕЛО] ",
    ["Function '%s()' has been deprecated - use '%s()' instead!"] = "Функция '%s()' устарела - используйте '%s()' вместо нее!",
    ["Addon loaded. Have a look at the the readme file for instructions."] = "Аддон загружен. Ознакомьтесь с файлом readme для получения инструкций.",
    ["Could not find the 'Start Fishing' spell in your spellbook! (did you remember to pick up the profession?)"] = "Не удалось найти заклинание «Начать рыбалку» в вашей книге заклинаний! (Вы не забыли выучить профессию?)",

    ["** '%s' is on cooldown!"] = "** '%s' на перезарядке!",
    ["** Attempting to use '%s'!"] = "** Пытаюсь использовать '%s'!",

    ["** No mage-gems found to use!"] = "** Не найдено самоцветов мага для использования!",
    ["** No healthstones found to use!"] = "** Не найдено камней здоровья для использования!",
    ["** No armor-potions found to use!"] = "** Не найдено зелий брони для использования!",
    ["** No health-potions found to use!"] = "** Не найдено зелий исцеления для использования!",
    ["** No exotic mana-potions found to use!"] = "** Не найдено экзотических зелий маны для использования!",
    ["** No standard mana-potions found to use!"] = "** Не найдено стандартных зелий маны для использования!",
};
