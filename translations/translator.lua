local _tostring = tostring;
local _strformat = string.format;

local _allTranslations = CerniesWonderfulFunctions.Translations;
local _activeLanguageSnapshot = CerniesWonderfulFunctions.ActiveLanguage;

function CerniesWonderfulFunctions.Translate(input)
    if not _activeLanguageSnapshot or _activeLanguageSnapshot == "enUS" or _activeLanguageSnapshot == "enGB" then
        -- no point to translate if the locale is enUS/enGB or nil   saves us a few unnecessary table-lookups
        return input;
    end
    
    local translationsTable = _allTranslations[_activeLanguageSnapshot]
    if not translationsTable then
        -- no localization table for this locale   return the input as-is in en-us locale
        return input;
    end

    return translationsTable[input] or input;
end

local _translateSnapshot = CerniesWonderfulFunctions.Translate
function CerniesWonderfulFunctions.TranslateFormatted(input, extraArg1, extraArg2, extraArg3, extraArg4, extraArg5, extraArg6, extraArg7, extraArg8, extraArg9, extraArg10)
    local translatedString = _translateSnapshot(input)

    return _strformat(translatedString, _tostring(extraArg1), _tostring(extraArg2), _tostring(extraArg3), _tostring(extraArg4), _tostring(extraArg5), _tostring(extraArg6), _tostring(extraArg7), _tostring(extraArg8), _tostring(extraArg9), _tostring(extraArg10));
end
