local _thisLocale = "zhCN";

if CerniesWonderfulFunctions.ActiveLanguage ~= _thisLocale then
    -- only load this file if the locale matches
    return
end

CerniesWonderfulFunctions.Translations[_thisLocale] = {
    ["[DEPRECATED] "] = "[已弃用] ",
    ["Function '%s()' has been deprecated - use '%s()' instead!"] = "函数 '%s()' 已弃用 - 请改用 '%s()'！",
    ["Addon loaded. Have a look at the the readme file for instructions."] = "插件已加载。请查看说明文件以获取使用说明。",
    ["Could not find the 'Start Fishing' spell in your spellbook! (did you remember to pick up the profession?)"] = "在你的魔法书中找不到“开始钓鱼”技能！（你是否忘记学习该专业？）",

    ["** '%s' is on cooldown!"] = "** '%s' 正在冷却！",
    ["** Attempting to use '%s'!"] = "** 正在尝试使用 '%s'！",

    ["** No mage-gems found to use!"] = "** 没有找到可用的法师宝石！",
    ["** No healthstones found to use!"] = "** 没有找到可用的治疗石！",
    ["** No armor-potions found to use!"] = "** 没有找到可用的护甲药水！",
    ["** No health-potions found to use!"] = "** 没有找到可用的治疗药水！",
    ["** No exotic mana-potions found to use!"] = "** 没有找到可用的奇异魔法药水！",
    ["** No standard mana-potions found to use!"] = "** 没有找到可用的标准魔法药水！",
};
