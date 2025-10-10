local _thisLocale = "koKR";

if CerniesWonderfulFunctions.ActiveLanguage ~= _thisLocale then
    -- only load this file if the locale matches
    return
end

CerniesWonderfulFunctions.Translations[_thisLocale] = {
    ["[DEPRECATED] "] = "[사용 중단] ",
    ["Function '%s()' has been deprecated - use '%s()' instead!"] = "함수 '%s()'는 사용 중단되었습니다 - 대신 '%s()'를 사용하세요!",
    ["Addon loaded. Have a look at the the readme file for instructions."] = "애드온이 로드되었습니다. 사용 설명서를 확인하여 지침을 확인하세요.",
    ["Could not find the 'Start Fishing' spell in your spellbook! (did you remember to pick up the profession?)"] = "주문책에서 '낚시 시작' 주문을 찾을 수 없습니다! (전문 기술을 선택했는지 확인했나요?)",

    ["** '%s' is on cooldown!"] = "** '%s'이(가) 재사용 대기 중입니다!",
    ["** Attempting to use '%s'!"] = "** '%s'을(를) 사용하려고 시도 중입니다!",

    ["** No mage-gems found to use!"] = "** 사용할 마법사 보석을 찾을 수 없습니다!",
    ["** No healthstones found to use!"] = "** 사용할 생명석을 찾을 수 없습니다!",
    ["** No armor-potions found to use!"] = "** 사용할 방어 물약을 찾을 수 없습니다!",
    ["** No health-potions found to use!"] = "** 사용할 치유 물약을 찾을 수 없습니다!",
    ["** No exotic mana-potions found to use!"] = "** 사용할 이국적인 마나 물약을 찾을 수 없습니다!",
    ["** No standard mana-potions found to use!"] = "** 사용할 표준 마나 물약을 찾을 수 없습니다!",
};
