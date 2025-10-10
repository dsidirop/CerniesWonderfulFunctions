local _thisLocale = "zhTW";

if CerniesWonderfulFunctions.ActiveLanguage ~= _thisLocale then
    -- only load this file if the locale matches
    return
end

CerniesWonderfulFunctions.Translations[_thisLocale] = {
    ["[DEPRECATED] "] = "[已棄用] ",
    ["Function '%s()' has been deprecated - use '%s()' instead!"] = "函數 '%s()' 已棄用 - 請改用 '%s()'！",
    ["Addon loaded. Have a look at the the readme file for instructions."] = "插件已載入。請查看說明文件以獲取使用說明。",
    ["Could not find the 'Start Fishing' spell in your spellbook! (did you remember to pick up the profession?)"] = "在你的魔法書中找不到「開始釣魚」技能！（你是否忘記學習該專業？）",

    ["** '%s' is on cooldown!"] = "** '%s' 正在冷卻！",
    ["** Attempting to use '%s'!"] = "** 正在嘗試使用 '%s'！",

    ["** No mage-gems found to use!"] = "** 沒有找到可用的法師寶石！",
    ["** No healthstones found to use!"] = "** 沒有找到可用的治療石！",
    ["** No armor-potions found to use!"] = "** 沒有找到可用的護甲藥水！",
    ["** No health-potions found to use!"] = "** 沒有找到可用的治療藥水！",
    ["** No exotic mana-potions found to use!"] = "** 沒有找到可用的奇異法力藥水！",
    ["** No standard mana-potions found to use!"] = "** 沒有找到可用的標準法力藥水！",
};
