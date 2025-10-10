local _tostring = tostring;
local _strformat = string.format;

local _allLocalizations = CerniesWonderfulFunctions.Localizations;
local _activeLanguageSnapshot = CerniesWonderfulFunctions.ActiveLanguage;

function CerniesWonderfulFunctions.Localize(input)
    if not _activeLanguageSnapshot or _activeLanguageSnapshot == "enUS" or _activeLanguageSnapshot == "enGB" then
        -- no point to translate if the locale is enUS/enGB or nil   saves us a few unnecessary table-lookups
        return input;
    end
    
    local localizationsTable = _allLocalizations[_activeLanguageSnapshot]
    if not localizationsTable then
        -- no localization table for this locale   return the input as-is in en-us locale
        return input;
    end

    return localizationsTable[input] or input;
end
