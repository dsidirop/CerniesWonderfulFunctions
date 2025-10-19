local L = CerniesWonderfulFunctions.Localize; --snapshot these shorthands for the sake of performance and convenience
local T = CerniesWonderfulFunctions.Translate;
local TF = CerniesWonderfulFunctions.TranslateFormatted;

local _isPlayerInCombat = false;

local _tostring = tostring

local _strsub = string.sub
local _strgsub = string.gsub
local _strfind = string.find
local _strlower = string.lower

local _getn = table.getn
local _pairs = pairs
local _ipairs = ipairs
local _tblsort = table.sort
local _tblinsert = table.insert

local _startFishing_localizedSpellName; -- cached localized spell names
local _druid__feralCharge__localizedSpellName;
local _druid__bestBearForm__localizedSpellName;
local _paladin__righteousFury__localizedSpellName;

local _allSpellbookSpellsOfCharacterIndexedBy_localizedSpellNames;
local _allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths;

local ROYAL_BLUE = { 0.39, 0.584, 0.929 };
local function _print(msg, r, g, b, id)
    DEFAULT_CHAT_FRAME:AddMessage(
            "[CWF] " .. msg,
            r ~= nil and r or ROYAL_BLUE[1],
            g ~= nil and g or ROYAL_BLUE[2],
            b ~= nil and b or ROYAL_BLUE[3],
            id
    )
end

local function _printWarning(msg)
    _print(msg, 1, 0.5, 0);
end

local function _printDeprecationWarning(msg)
    _printWarning(T("[DEPRECATED] ") .. msg);
end


local function _strtrim(input)
    return _strgsub(input or "", "^%s*(.-)%s*$", "%1")
end

local function _strsplit(self, delimiter)
    local result = { }
    local from = 1
    local delim_from, delim_to = _strfind(self, delimiter, from)
    while delim_from do
        _tblinsert(result, _strsub(self, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = _strfind(self, delimiter, from)
    end
    _tblinsert(result, _strsub(self, from))
    return result
end

local function CerniesWonderfulFunctions_OnEvent()
    local eventSnapshot = event;
    local argument1Snapshot = arg1;

    if eventSnapshot == "ADDON_LOADED" then
        if argument1Snapshot ~= "CerniesWonderfulFunctions" then
            return
        end

        _print(T "Addon loaded. Have a look at the the readme file for instructions.");
        return
    end

    if eventSnapshot == "PLAYER_REGEN_DISABLED" then
        _isPlayerInCombat = true;
        return
    end

    if eventSnapshot == "PLAYER_REGEN_ENABLED" then
        _isPlayerInCombat = false;
        return
    end

    if eventSnapshot == "SPELL_UPDATE" then
        -- reset these so they get looked up afresh next time they are used
        _startFishing_localizedSpellName = nil;
        _druid__feralCharge__localizedSpellName = nil;
        _druid__bestBearForm__localizedSpellName = nil;
        _paladin__righteousFury__localizedSpellName = nil;

        _allSpellbookSpellsOfCharacterIndexedBy_localizedSpellNames = nil;
        _allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths = nil;
        return
    end
end

local _rootFrame = CreateFrame("Frame", "CerniesWonderfulFunctionsFrame", UIParent);
_rootFrame:RegisterEvent("ADDON_LOADED") -- :SetScript("OnLoad", ...) would not work because it only works if defined via the xml file!
_rootFrame:RegisterEvent("SPELL_UPDATE");
_rootFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
_rootFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
_rootFrame:SetScript("OnEvent", CerniesWonderfulFunctions_OnEvent)

function UseBestBandage()
    UseBGBandage(
            L "Warsong Gulch Runecloth Bandage",
            L "Arathi Basin Runecloth Bandage",
            L "Alterac Heavy Runecloth Bandage",
            L "Heavy Runecloth Bandage",
            L "Runecloth Bandage",
            L "Heavy Mageweave Bandage",
            L "Mageweave Bandage",
            L "Heavy Silk Bandage",
            L "Silk Bandage",
            L "Heavy Linen Bandage",
            L "Linen Bandage",
            L "Heavy Wool Bandage",
            L "Wool Bandage"
    );
end

--One action for using Battleground specific bandages, or use normal bandages if not in a Battleground
function UseBGBandage(
        wg,
        ab,
        av,
        normal01,
        normal02,
        normal03,
        normal04,
        normal05,
        normal06,
        normal07,
        normal08,
        normal09,
        normal10,
        normal11,
        normal12,
        normal13,
        normal14,
        normal15
)
    --'Warsong Gulch Runecloth Bandage''Alterac Heavy Runecloth Bandage''Arathi Basin Runecloth Bandage''Heavy Runecloth Bandage'
    local msg;
    local zone = GetRealZoneText(); -- get the localized zone-name
    local wgFound, wgBag, wgSlot = isInBag(wg);
    local abFound, abBag, abSlot = isInBag(ab);
    local avFound, avBag, avSlot = isInBag(av);

    if (zone == L "Warsong Gulch" and wgFound == true) then
        UseContainerItem(wgBag, wgSlot);
        msg = wg;
    elseif (zone == L "Alterac Valley" and avFound == true) then
        UseContainerItem(avBag, avSlot);
        msg = av;
    elseif (zone == L "Arathi Basin" and abFound == true) then
        UseContainerItem(abBag, abSlot);
        msg = ab;
    else
        local normals = {
            normal01, normal02, normal03, normal04, normal05,
            normal06, normal07, normal08, normal09, normal10,
            normal11, normal12, normal13, normal14, normal15
        };
        for i = 1, _getn(normals), 1 do
            local normalFound, normalBag, normalSlot = isInBag(normals[i]);
            if (normalFound == true) then
                UseContainerItem(normalBag, normalSlot);
                msg = normals[i];
                break ;
            end
        end

        if msg == nil then
            msg = "Nothing";
        end
    end

    _print(TF("** Attempting to use '%s'!", msg));
end

-- returns spell-book-index-number of a spell from player's spellbook   bare in mind that the
-- spell-book-index-number is not the same as the spell-id and cannot be used interchangeably
-- so it cannot be passed to CastSpellByName() as-is
function getSpellId(targetSpellName)
    local i = 1
    while true do
        local spellName, _ = GetSpellName(i, BOOKTYPE_SPELL)
        if not spellName then
            break
        end

        if spellName == targetSpellName then
            return i;
        end

        i = i + 1;
    end

    return nil;
end

local function getAllSpellsOfCurrentPlayerOnce()
    if _allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths then
        return _allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths, _allSpellbookSpellsOfCharacterIndexedBy_localizedSpellNames
    end

    _allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths = {}

    local numTabs = GetNumSpellTabs()
    for tab = 1, numTabs do
        local _, _, offset, numSpells = GetSpellTabInfo(tab)
        for spellIndexInSpellbook = offset + 1, offset + numSpells do
            local localizedSpellName, spellRank = GetSpellName(spellIndexInSpellbook, BOOKTYPE_SPELL)

            localizedSpellName = _strtrim(localizedSpellName or "") -- dont lowercase this one
            if localizedSpellName ~= "" then
                local spellTexture = GetSpellTexture(spellIndexInSpellbook, BOOKTYPE_SPELL)

                spellTexture = _strlower(_strtrim(spellTexture)) -- for case-insensitive comparison
                if spellTexture ~= "" then
                    if not _allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths[spellTexture] then
                        _allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths[spellTexture] = {}
                    end

                    _tblinsert(_allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths[spellTexture], {
                        localizedSpellName = localizedSpellName, -- localized spell name

                        rank = spellRank, -- racial traits that have a single rank set this to "Racial" and professions to "Specialization/Artisan/etc"
                        texture = spellTexture,
                        spellIndex = spellIndexInSpellbook --00 not to be confused with spellId which is different

                        -- spellId = ...   unfortunately in vanilla wow there is no way to get the numeric-spell-id :(
                    })
                end
            end
        end
    end

    -- now sort spell-ranks in descending order (highest -> lowest) and then create a side-map indexed by spell-name too
    _allSpellbookSpellsOfCharacterIndexedBy_localizedSpellNames = {}
    for texture, spells in _pairs(_allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths) do
        _tblsort(spells, function(a, b)
            if a.rank == b.rank then
                -- keep this check first to account for nils on both sides   shouldnt happen but just in case
                return false
            end

            if a.rank == nil then
                -- shouldnt happen but just in case
                return true
            end

            if b.rank == nil then
                -- shouldnt happen but just in case
                return false
            end

            return a.rank > b.rank
        end)

        _allSpellbookSpellsOfCharacterIndexedBy_localizedSpellNames[spells[1].localizedSpellName] = spells
    end

    return _allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths, _allSpellbookSpellsOfCharacterIndexedBy_localizedSpellNames

    --00  be careful not to confuse the spell-index number with the numeric-spell-id of the spell they are not the same
    --    and in fact in vanilla wow we cannot automatically get the numeric-spell-id of the spell in any way
end

function printAllSpellsOfCurrentPlayer()
    local _, spellsIndexedBy_localizedSpellNames = getAllSpellsOfCurrentPlayerOnce();

    _print("All spells of current player (total " .. _tostring(_getn(spellsIndexedBy_localizedSpellNames)) .. " distinct spell names):");

    for localizedSpellName, spells in _pairs(spellsIndexedBy_localizedSpellNames) do
        _print("** localizedSpellName='" .. localizedSpellName .. "'")
        for _, spell in _ipairs(spells) do
            _print(
                    "**** "
                            .. "rank='" .. _tostring(spell.rank) .. "', "
                            .. "texture='" .. spell.texture .. "', "
                            .. "spellIndex=" .. spell.spellIndex
            )
        end
    end
end

-- returns true if the player has the given spell in their spellbook
function haveSpell(localizedSpellBaseName, optionalRank)
    local _, spellsIndexedBy_localizedSpellNames = getAllSpellsOfCurrentPlayerOnce();

    return spellsIndexedBy_localizedSpellNames[localizedSpellBaseName] ~= nil and ( --@formatter:off
            optionalRank == nil
        or  spellsIndexedBy_localizedSpellNames[localizedSpellBaseName][optionalRank] ~= nil
    ) --@formatter:on
end

-- returns id of a spell from player's spellbook based on the given texture-regex
-- (case sensitive) very useful for detecting spells dynamically even on non-english clients!
function tryGetLocalizedSpellNameByExactTextureFilePath(fullTextureFilePath)
    local allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths = getAllSpellsOfCurrentPlayerOnce();

    local allSpellRanks = allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths[_strlower(fullTextureFilePath)];
    if not allSpellRanks or not allSpellRanks[1] then
        return nil;
    end

    return allSpellRanks[1].localizedSpellName;
end

function tryGetLocalizedSpellNameByRegexedTextureFilePath(regexedFullTextureFilePath)
    local allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths = getAllSpellsOfCurrentPlayerOnce();

    for textureFilePath, allSpellRanks in _pairs(allSpellbookSpellsOfCharacterIndexedBy_lowercasedTextureFilepaths) do
        if _strfind(textureFilePath, regexedFullTextureFilePath) then
            return allSpellRanks[1].localizedSpellName;
        end
    end

    return nil;
end

--One action for using Battleground specific biscuits instead of regular food/water
function UseBGBiscuit(wg, ab, av)
    --'Warsong Gulch Enriched Ration''Alterac Manna Biscuit''Arathi Basin Enriched Ration'
    local zone = GetRealZoneText(); -- get the localized zone-name
    local msg;
    local wgFound, wgBag, wgSlot = isInBag(wg);
    local abFound, abBag, abSlot = isInBag(ab);
    local avFound, avBag, avSlot = isInBag(av);

    if (zone == L "Warsong Gulch" and wgFound == true) then
        UseContainerItem(wgBag, wgSlot);
        msg = wg;
    elseif (zone == L "Alterac Valley" and avFound == true) then
        UseContainerItem(avBag, avSlot);
        msg = av;
    elseif (zone == L "Arathi Basin" and abFound == true) then
        UseContainerItem(abBag, abSlot);
        msg = ab;
    elseif (avFound == true) then
        UseContainerItem(avBag, avSlot);
        msg = av;
    else
        _print(TF("** No biscuits found!", msg));
        return;
    end

    _print(TF("** Attempting to use '%s'!", msg));
end

--One action for drinking and eating, press twice to do both
function Nom(water, food)
    local waterFound, waterBag, waterSlot = isInBag(water);
    local foodFound, foodBag, foodSlot = isInBag(food);
    local healthPct = UnitHealth("player") / UnitHealthMax("player");
    local manaPct = UnitMana("player") / UnitManaMax("player");

    if (_isPlayerInCombat == false) then
        if (isBuffNameActive("Drink") == false and waterFound == true and manaPct ~= 1) then
            UseContainerItem(waterBag, waterSlot, 1);
        elseif (isBuffNameActive("Food") == false and foodFound == true and healthPct ~= 1) then
            UseContainerItem(foodBag, foodSlot, 1);
        end
    end
end

--One action for eating for non mana using classes
function NomFood(food)
    local foodFound, foodBag, foodSlot = isInBag(food);
    local healthPct = UnitHealth("player") / UnitHealthMax("player");

    if (_isPlayerInCombat == false) then
        if (isBuffNameActive("Food") == false and foodFound == true and healthPct ~= 1) then
            UseContainerItem(foodBag, foodSlot, 1);
        end
    end
end

--One action for drinking for mana using classes
function NomWater(water)
    local waterFound, waterBag, waterSlot = isInBag(water);
    local manaPct = UnitMana("player") / UnitManaMax("player");

    if (_isPlayerInCombat == false) then
        if (isBuffNameActive("Drink") == false and waterFound == true and manaPct ~= 1) then
            UseContainerItem(waterBag, waterSlot, 1);
        end
    end
end

local STANDARD_MANA_POTIONS = {
    L 'Major Mana Draught', -- best ones
    L 'Major Mana Potion',
    L 'Combat Mana Potion',
    L 'Wildvine Potion',
    L 'Superior Mana Potion',
    L 'Greater Mana Potion',
    L 'Mana Potion',
    L 'Lesser Mana Potion',
    L 'Minor Mana Potion', -- worst ones
};

--One action to use a Mana potion based on location and item availability
function UseManaPotion()
    local zone = GetRealZoneText(); -- get the localized zone-name

    local potFound, potBag, potSlot, duration;

    --based on battleground zone use 'Major Mana Draught'
    potFound, potBag, potSlot = isInBag(STANDARD_MANA_POTIONS[1]);
    if (potFound == true and (zone == L "Warsong Gulch" or zone == L "Alterac Valley" or zone == L "Arathi Basin")) then
        _, duration, _ = GetContainerItemCooldown(potBag, potSlot);
        if (duration == 0) then
            UseContainerItem(potBag, potSlot, 1);
            _print(TF("** Attempting to use '%s'!", STANDARD_MANA_POTIONS[1]))
        else
            _print(TF("** '%s' is on cooldown!", STANDARD_MANA_POTIONS[1]))
        end
        return;
    end

    --otherwise loop through the rest of the possible potions and use the highest value potion available
    for i = 2, _getn(STANDARD_MANA_POTIONS) do
        potFound, potBag, potSlot = isInBag(STANDARD_MANA_POTIONS[i]);
        if (potFound) then
            _, duration, _ = GetContainerItemCooldown(potBag, potSlot);
            if (duration == 0) then
                UseContainerItem(potBag, potSlot, 1);
                _print(TF("** Attempting to use '%s'!", STANDARD_MANA_POTIONS[i]))
            else
                _print(TF("** '%s' is on cooldown!", STANDARD_MANA_POTIONS[i]))
            end
            return;
        end
    end

    _print(T "** No standard mana-potions found to use!")
end

local EXOTIC_MANA_BOOSTERS = { L "Nordanaar Herbal Tea", L "Dark Rune", L "Demonic Rune" }

--One action to use an exotic Mana booster based on item availability
function UseExoticManaBooster()
    local potFound, potBag, potSlot, duration
    for i = 1, _getn(potion) do
        potFound, potBag, potSlot = isInBag(EXOTIC_MANA_BOOSTERS[i])
        if (potFound) then
            _, duration, _ = GetContainerItemCooldown(potBag, potSlot)
            if (duration == 0) then
                UseContainerItem(potBag, potSlot, 1)
                _print(TF("** Attempting to use '%s'!", EXOTIC_MANA_BOOSTERS[i]))
            else
                _print(TF("** '%s' is on cooldown!", EXOTIC_MANA_BOOSTERS[i]))
            end
            break
        end
    end

    _print(T "** No exotic mana-potions found to use!")
end

local ARMOR_POTIONS = { L "Greater Stoneshield Potion", L "Lesser Stoneshield Potion" }

--One action to use an armor potion based on item availability
function UseArmorPotion()
    local potFound, potBag, potSlot, duration
    for i = 1, _getn(ARMOR_POTIONS) do
        potFound, potBag, potSlot = isInBag(ARMOR_POTIONS[i])
        if potFound then
            _, duration, _ = GetContainerItemCooldown(potBag, potSlot)
            if (duration == 0) then
                UseContainerItem(potBag, potSlot, 1)
                _print(TF("** Attempting to use '%s'!", ARMOR_POTIONS[i]))
            else
                _print(TF("** '%s' is on cooldown!", ARMOR_POTIONS[i]))
            end
            return
        end
    end

    _print(T "** No armor-potions found to use!")
end

local STANDARD_HEALTH_POTIONS = {
    L "Major Healing Draught", -- best ones
    L "Major Healing Potion",
    L "Combat Healing Potion",
    L "Superior Healing Potion",
    L "Greater Healing Potion",
    L "Healing Potion",
    L "Lesser Healing Potion",
    L "Minor Healing Potion", -- worst ones
};

--One action to use a Health potion based on location and item availability
function UseHealthPotion()
    local zone = GetRealZoneText(); -- get the localized zone-name
    local potFound, potBag, potSlot, duration;

    --based on battleground zone use 'Major Healing Draught'
    potFound, potBag, potSlot = isInBag(STANDARD_HEALTH_POTIONS[1]);
    if (potFound == true and (zone == L "Warsong Gulch" or zone == L "Alterac Valley" or zone == L "Arathi Basin")) then
        _, duration, _ = GetContainerItemCooldown(potBag, potSlot);
        if (duration == 0) then
            UseContainerItem(potBag, potSlot, 1);
            _print(TF("** Attempting to use '%s'!", STANDARD_HEALTH_POTIONS[1]));
        else
            _print(TF("** '%s' is on cooldown!", STANDARD_HEALTH_POTIONS[1]));
        end
        return
    end

    --otherwise loop through the rest of the possible potions and use the highest value potion available
    for i = 2, _getn(STANDARD_HEALTH_POTIONS), 1 do
        potFound, potBag, potSlot = isInBag(STANDARD_HEALTH_POTIONS[i]);
        if (potFound) then
            _, duration, _ = GetContainerItemCooldown(potBag, potSlot);
            if (duration == 0) then
                UseContainerItem(potBag, potSlot, 1);
                _print(TF("** Attempting to use '%s'!", STANDARD_HEALTH_POTIONS[i]));
            else
                _print(TF("** '%s' is on cooldown!", STANDARD_HEALTH_POTIONS[i]));
            end
            break
        end
    end

    _print(T "** No health-potions found to use!")
end

local MAGE_MANA_GEMS = { L "Mana Ruby", L "Mana Citrine", L "Mana Jade", L "Mana Agate" };

--Uses available Mana Gem
function UseManaGem()
    local hasGem, gemBag, gemSlot;
    for i = 1, _getn(MAGE_MANA_GEMS) do
        hasGem, gemBag, gemSlot = isInBag(MAGE_MANA_GEMS[i]);
        if (hasGem == true) then
            UseContainerItem(gemBag, gemSlot, 1);
            _print(TF("** Attempting to use '%s'!", MAGE_MANA_GEMS[i]));
            return;
        end
    end

    _print(T "** No mage-gems found to use!")
end

local HEALTHSTONES = {
    L "Major Healthstone", -- best ones
    L "Greater Healthstone",
    L "Healthstone",
    L "Lesser Healthstone",
    L "Minor Healthstone" -- worst ones
};

--Uses available Healthstone
function UseHealthstone()
    local hasStone, stoneBag, stoneSlot;
    for i = 1, _getn(HEALTHSTONES) do
        hasStone, stoneBag, stoneSlot = isInBag(HEALTHSTONES[i]);
        if (hasStone == true) then
            UseContainerItem(stoneBag, stoneSlot, 1);
            _print(TF("** Attempting to use '%s'!", HEALTHSTONES[i]));
            return
        end
    end
    
    _print(T "** No healthstones found to use!")
end

--Decide which spell to cast based on Clearcast proc
function MageDPM(spell1, spell2)
    local clearcast = isBuffNameActive("Clearcasting"); -- todo convert this over to use texture-based-buff detection so that it will work on non-english clients!

    if (clearcast) then
        SpellStopCasting();
        CastSpellByName(spell1);
    else
        CastSpellByName(spell2);
    end

end

local SPELL__START_FISHING__TEXTURE_FILEPATH_REGEX = "[Tt][Rr][Aa][Dd][Ee].*[Ff][Ii][Ss][Hh][Ii][Nn][Gg]$"; -- trade_fishing

local function tryGetLocalizedSpellNameFor_startFishingSpell()
    _startFishing_localizedSpellName = _startFishing_localizedSpellName
            or tryGetLocalizedSpellNameByRegexedTextureFilePath(SPELL__START_FISHING__TEXTURE_FILEPATH_REGEX) --00
            or ""; -- start-fishing spell not found

    return _startFishing_localizedSpellName ~= ""
            and _startFishing_localizedSpellName
            or nil;

    -- 00   this should work on all clients because the texture is the same everywhere
end

--Equip Fishing pole or begin fishing if a pole is equipped, holding down any modifier (ctrl, alt, shift) will attach the best available lure
function Fish(pole)
    local localizedSpellNameForStartFishingSpell = tryGetLocalizedSpellNameFor_startFishingSpell();
    if not localizedSpellNameForStartFishingSpell then
        _printWarning(T "Could not find the 'Start Fishing' spell in your spellbook! (did you remember to pick up the profession?)");
        return
    end

    local mainHandLink = GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot"));
    local mainHandName = getItemName(mainHandLink);
    local pole_hasPole, pole_bag, pole_slot = isInBag(pole);
    local mod = false;
    local lures = {
        L "Aquadynamic Fish Attractor", -- strongest lures
        L "Flesh Eating Worm",
        L "Bright Baubles",
        L "Nightcrawlers",
        L "Shiny Bauble" -- weakest lures
    };
    local lureFound, lureBag, lureSlot;

    if (IsAltKeyDown() or IsShiftKeyDown() or IsControlKeyDown()) then
        mod = true;
    end

    if (pole_hasPole == true and (mainHandLink == nil or mainHandName ~= pole)) then
        UseContainerItem(pole_bag, pole_slot, 1);
    elseif (mod == true) then
        for i = 1, _getn(lures), 1 do
            lureFound, lureBag, lureSlot = isInBag(lures[i]);
            if (lureFound) then
                UseContainerItem(lureBag, lureSlot);
                PickupInventoryItem(16);
                break ;
            end
        end
    elseif (mainHandName ~= nil and mainHandName == pole) then
        CastSpellByName(localizedSpellNameForStartFishingSpell, true);
    end
end

--Toggle equipped item slot between two items
function ToggleEquipItemSlot(slot, item1, item2)
    local equippedItem = getItemName(GetInventoryItemLink("player", GetInventorySlotInfo(slot)));
    local item1_hasItem, item1_bag, item1_slot = isInBag(item1);
    local item2_hasItem, item2_bag, item2_slot = isInBag(item2);

    if (item1_hasItem == true and (equippedItem == nil or equippedItem ~= item1)) then
        UseContainerItem(item1_bag, item1_slot, 1);
    elseif (item2_hasItem == true) then
        UseContainerItem(item2_bag, item2_slot, 1);
    end
end

--Druid shapeshift, form is the name of the shape, isPowerShift determines whether to cancel target form and reshift into it, isGCD is true/false to determine if the shift waits until GCD is up.
function Shapeshift(form, isPowerShift, isGCD)
    local targetFormId = 0;
    local currentForm = 0;
    local formName, active, shiftCooldown;
    local isShiftCd = isSpellOnCd(form);

    _, formName, active = GetShapeshiftFormInfo(1);
    _, shiftCooldown, _ = GetSpellCooldown(getSpellId(formName), BOOKTYPE_SPELL);

    for i = 1, GetNumShapeshiftForms(), 1
    do
        _, formName, active = GetShapeshiftFormInfo(i);
        if (_strfind(formName, form)) then
            targetFormId = i;
        end
        if (active ~= nil) then
            currentForm = i;
        end
    end
    --if already in target form and powershift true or in a different form other than target form, cancelshapeshift
    if ((targetFormId == currentForm and isPowerShift == true) or (targetFormId ~= currentForm and currentForm ~= 0)) then
        --if((isGCD == false) or (isGCD == true and shiftCooldown == 0)) then
        if ((isGCD == false) or (isGCD == true and not isShiftCd)) then
            CastShapeshiftForm(currentForm);
        end
        --if in human form, shift into target form
    elseif (currentForm == 0) then
        --if((isGCD == false) or (isGCD == true and shiftCooldown == 0)) then
        if ((isGCD == false) or (isGCD == true and not isShiftCd)) then
            CastShapeshiftForm(targetFormId);
        end
    end
end

--Druid cancel shapeshift
function CancelShapeshift()
    local currentForm = 0;
    local formName, active;
    for i = 1, GetNumShapeshiftForms(), 1
    do
        _, formName, active = GetShapeshiftFormInfo(i);
        if (active ~= nil) then
            currentForm = i;
        end
    end
    if (currentForm ~= 0) then
        CastShapeshiftForm(currentForm);
    end
end

-- druid macro for shifting into bear-form and using feral-charge
local DRUID__FERAL_CHARGE__TEXTURE_PATH_REGEX = "[Aa][Bb][Ii][Ll][Ii][Tt][Yy].*[Dd][Rr][Uu][Ii][Dd].*[Ff][Ee][Rr][Aa][Ll].*[C][Hh][Aa][Rr][Gg][Ee]$"; -- ability_druid_feralcharge
local function tryGetLocalizedSpellNameFor_druidFeralCharge()
    _druid__feralCharge__localizedSpellName = _druid__feralCharge__localizedSpellName
            or tryGetLocalizedSpellNameByRegexedTextureFilePath(DRUID__FERAL_CHARGE__TEXTURE_PATH_REGEX) --00
            or ""; -- druid doesnt have feral charge

    return _druid__feralCharge__localizedSpellName ~= ""
            and _druid__feralCharge__localizedSpellName
            or nil;

    -- 00   this should work on all clients because the texture is the same everywhere
end

local DRUID__ANY_BEAR_FORM__TEXTURE_PATH_REGEX = "[Aa][Bb][Ii][Ll][Ii][Tt][Yy].*[Rr][Aa][Cc][Ii][Aa][Ll].*[Bb][Ee][Aa][Rr].*[Ff][Oo][Rr][Mm]$"; -- ability_racial_bearform    matches both "bear form" and "dire bear form"
local function tryGetLocalizedSpellNameFor_druidBestBearForm()
    _druid__bestBearForm__localizedSpellName = _druid__bestBearForm__localizedSpellName
            or tryGetLocalizedSpellNameByRegexedTextureFilePath(DRUID__ANY_BEAR_FORM__TEXTURE_PATH_REGEX) --00
            or ""; -- druid doesnt have bear form

    return _druid__bestBearForm__localizedSpellName ~= ""
            and _druid__bestBearForm__localizedSpellName
            or nil;

    -- 00   both "bear form" and "dire bear form" have the exact same texture
end

local DRUID_STANCE__BEARFORM = 1;
function FeralCharge()
    local bestBearFormIfAvailable = tryGetLocalizedSpellNameFor_druidBestBearForm();
    local feralChargeSpellNameIfAvailable = tryGetLocalizedSpellNameFor_druidFeralCharge();

    if not bestBearFormIfAvailable or not feralChargeSpellNameIfAvailable then
        return -- no point continuing if the druid lacks bear-form / feral-charge spells altogether
    end

    if getShapeshiftForm() == DRUID_STANCE__BEARFORM then
        CastSpellByName(feralChargeSpellNameIfAvailable);
        return
    end

    Shapeshift(bestBearFormIfAvailable, false, true);
end

--Druid macro to return current form id
function getShapeshiftForm()
    local currentForm = 0;
    local formName, active;
    for i = 1, GetNumShapeshiftForms(), 1
    do
        _, formName, active = GetShapeshiftFormInfo(i);
        if (active ~= nil) then
            currentForm = i;
        end
    end
    return currentForm;
end

--Create Frame to read tooltip
function createTooltipFrame()
    if cernieUsefulFunctions == nil then
        cernieUsefulFunctions = CreateFrame("GameTooltip", "cernieUsefulFunctionsTooltip", nil, "GameTooltipTemplate");
        cernieUsefulFunctionsTooltip:Hide(); -- order
        cernieUsefulFunctionsTooltip:SetOwner(WorldFrame, "ANCHOR_NONE"); -- order
    end
end

-----------------------------------------------

local function findActiveBuffsViaTexturesImpl(unit, exactMatchingNotRegex, stopAtFirstMatch, buff1, buff2, buff3, buff4, buff5, buff6, buff7, buff8, buff9, buff10, buff11, buff12, buff13, buff14, buff15)
    unit = unit or "player";

    stopAtFirstMatch = stopAtFirstMatch == nil
            and true
            or stopAtFirstMatch;

    exactMatchingNotRegex = exactMatchingNotRegex == nil
            and true
            or exactMatchingNotRegex;

    -- print("*********")
    -- print("** [" .. time() .. "] findActiveBuffsViaTexturesImpl: unit=" .. _tostring(unit) .. ", exactMatchingNotRegex=" .. _tostring(exactMatchingNotRegex) .. ", stopAtFirstMatch=" .. _tostring(stopAtFirstMatch))
    -- print("** [" .. time() .. "] buff1='" .. _tostring(buff1) .. "'")
    -- print("** [" .. time() .. "] buff2='" .. _tostring(buff2) .. "'")
    -- print("** [" .. time() .. "] buff3='" .. _tostring(buff3) .. "'")

    local
    buffIndex,
    matchedBuffs,
    matchedBuffsCount,
    currentBuffTexture,
    currentBuffIsMatching = -1, nil, 0, nil, false;
    for i = 32, 0, -1 do
        --00 exhaustive search from 32 (most recent buff) down to 0 (oldest buff)

        -- print("*****")

        buffIndex = GetPlayerBuff(i)
        if buffIndex ~= nil and buffIndex >= 0 then
            -- better not to break out of the loop if we get an intermittent negative or nil
            currentBuffTexture = GetPlayerBuffTexture(buffIndex)

            if currentBuffTexture ~= nil then
                if exactMatchingNotRegex then
                    currentBuffTexture = _strlower(currentBuffTexture);
                    buff1 = buff1 ~= nil and _strlower(buff1) or nil; -- prepare for case-insensitive comparison
                    buff2 = buff2 ~= nil and _strlower(buff2) or nil;
                    buff3 = buff3 ~= nil and _strlower(buff3) or nil;
                    buff4 = buff4 ~= nil and _strlower(buff4) or nil;
                    buff5 = buff5 ~= nil and _strlower(buff5) or nil;
                    buff6 = buff6 ~= nil and _strlower(buff6) or nil;
                    buff7 = buff7 ~= nil and _strlower(buff7) or nil;
                    buff8 = buff8 ~= nil and _strlower(buff8) or nil;
                    buff9 = buff9 ~= nil and _strlower(buff9) or nil;
                    buff10 = buff10 ~= nil and _strlower(buff10) or nil;
                    buff11 = buff11 ~= nil and _strlower(buff11) or nil;
                    buff12 = buff12 ~= nil and _strlower(buff12) or nil;
                    buff13 = buff13 ~= nil and _strlower(buff13) or nil;
                    buff14 = buff14 ~= nil and _strlower(buff14) or nil;
                    buff15 = buff15 ~= nil and _strlower(buff15) or nil;
                end

                --@formatter:off
                currentBuffIsMatching =
                           (  buff1 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff1 ) or (not exactMatchingNotRegex and _strfind(currentBuffTexture,  buff1))) )
                        or (  buff2 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff2 ) or (not exactMatchingNotRegex and _strfind(currentBuffTexture,  buff2))) )
                        or (  buff3 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff3 ) or (not exactMatchingNotRegex and _strfind(currentBuffTexture,  buff3))) )
                        or (  buff4 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff4 ) or (not exactMatchingNotRegex and _strfind(currentBuffTexture,  buff4))) )
                        or (  buff5 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff5 ) or (not exactMatchingNotRegex and _strfind(currentBuffTexture,  buff5))) )
                        or (  buff6 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff6 ) or (not exactMatchingNotRegex and _strfind(currentBuffTexture,  buff6))) )
                        or (  buff7 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff7 ) or (not exactMatchingNotRegex and _strfind(currentBuffTexture,  buff7))) )
                        or (  buff8 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff8 ) or (not exactMatchingNotRegex and _strfind(currentBuffTexture,  buff8))) )
                        or (  buff9 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff9 ) or (not exactMatchingNotRegex and _strfind(currentBuffTexture,  buff9))) )
                        or ( buff10 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff10) or (not exactMatchingNotRegex and _strfind(currentBuffTexture, buff10))) )
                        or ( buff11 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff11) or (not exactMatchingNotRegex and _strfind(currentBuffTexture, buff11))) )
                        or ( buff12 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff12) or (not exactMatchingNotRegex and _strfind(currentBuffTexture, buff12))) )
                        or ( buff13 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff13) or (not exactMatchingNotRegex and _strfind(currentBuffTexture, buff13))) )
                        or ( buff14 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff14) or (not exactMatchingNotRegex and _strfind(currentBuffTexture, buff14))) )
                        or ( buff15 ~= nil and ((exactMatchingNotRegex and currentBuffTexture == buff15) or (not exactMatchingNotRegex and _strfind(currentBuffTexture, buff15))));
                --@formatter:on

                -- print("** [" .. time() .. "] i=" .. _tostring(i) .. ", currentBuffIsMatching=" .. _tostring(currentBuffIsMatching) .. ", buffIndex=" .. _tostring(buffIndex) .. ", currentBuffTexture=" .. _tostring(currentBuffTexture))

                if currentBuffIsMatching then
                    -- print("** [" .. time() .. "] Matching buff found: currentBuffTexture=" .. _tostring(currentBuffTexture) .. " at buffIndex=" .. _tostring(buffIndex))

                    matchedBuffs = matchedBuffs or {}; -- lazy allocation
                    _tblinsert(matchedBuffs, {
                        Index = buffIndex, --  todo  in vanilla-wow we should return 'i' (zero-based) but from tbc-wow onwards we MIGHT have to return 'i + 1' if it turns out that the indices are still zero based (doubt it)
                        BuffTexture = currentBuffTexture,
                    });

                    matchedBuffsCount = matchedBuffsCount + 1;

                    if stopAtFirstMatch then
                        break ;
                    end
                end
            end
        end
    end

    if matchedBuffsCount == 0 then
        return nil, 0;
    end

    return matchedBuffs;

    --00  in twow this method sometimes returns nil even if a buff does in fact exist at the given index
    --    we should not get tricked and break out of the loop early in that case
end

-- Reads unit's buffs and returns (matchesArray, matchedBuffsCount) where matchesArray is an array of elements { Index = (number), BuffTexture = (string) }
-- sorted by descending buff-index (ie: highest buff-index first) or nil if no buffs matched
--
-- Note that string-matching is applied in a case-insensitive manner.
--
-- Example usage:
--
--        local matchedBuffs = findActiveBuffs("player", "Shadow Resistance Aura", "Blessing of Wisdom", "Seal of Wisdom")
--        if matchedBuffs ~= nil then
--            for _, buffInfo in _pairs(matchedBuffs) do
--                print("** index=" .. buffInfo.Index .. ", name='" .. buffInfo.BuffTexture .. "'")
--            end
--        end
--
function findActiveBuffsViaTextures(unit, exactBuffTexture1, exactBuffTexture2, exactBuffTexture3, exactBuffTexture4, exactBuffTexture5, exactBuffTexture6, exactBuffTexture7, exactBuffTexture8, exactBuffTexture9, exactBuffTexture10, exactBuffTexture11, exactBuffTexture12, exactBuffTexture13, exactBuffTexture14, exactBuffTexture15)
    local matchesArray, matchedBuffsCount = findActiveBuffsViaTexturesImpl(
            unit,
            true, --   exactMatchingNotRegex = true
            false, --       stopAtFirstMatch = false
            exactBuffTexture1,
            exactBuffTexture2,
            exactBuffTexture3,
            exactBuffTexture4,
            exactBuffTexture5,
            exactBuffTexture6,
            exactBuffTexture7,
            exactBuffTexture8,
            exactBuffTexture9,
            exactBuffTexture10,
            exactBuffTexture11,
            exactBuffTexture12,
            exactBuffTexture13,
            exactBuffTexture14,
            exactBuffTexture15
    );

    return matchesArray, matchedBuffsCount;
end

-- Reads unit's buffs and returns (matchesArray, matchedBuffsCount) where matchesArray is an array of elements { Index = (number), BuffTexture = (string) }
-- sorted by descending buff-index (ie: highest buff-index first) or nil if no buffs matched
--
-- Note that the regexes are applied in a case-sensitive manner.
--
-- Example usage:
--
--        local matchedBuffs = findActiveBuffsViaRegexedTextures("player", ".*_Holy_", ".*_Devotion$")
--        if matchedBuffs ~= nil then
--            for _, buffInfo in _pairs(matchedBuffs) do
--                print("** index=" .. buffInfo.Index .. ", name='" .. buffInfo.BuffTexture .. "'")
--            end
--        end
--
function findActiveBuffsViaRegexedTextures(unit, buffTextureRegex1, buffTextureRegex2, buffTextureRegex3, buffTextureRegex4, buffTextureRegex5, buffTextureRegex6, buffTextureRegex7, buffTextureRegex8, buffTextureRegex9, buffTextureRegex10, buffTextureRegex11, buffTextureRegex12, buffTextureRegex13, buffTextureRegex14, buffTextureRegex15)
    local matchesArray, matchedBuffsCount = findActiveBuffsViaTexturesImpl(
            unit,
            false, -- exactMatchingNotRegex = false
            false, --      stopAtFirstMatch = false
            buffTextureRegex1,
            buffTextureRegex2,
            buffTextureRegex3,
            buffTextureRegex4,
            buffTextureRegex5,
            buffTextureRegex6,
            buffTextureRegex7,
            buffTextureRegex8,
            buffTextureRegex9,
            buffTextureRegex10,
            buffTextureRegex11,
            buffTextureRegex12,
            buffTextureRegex13,
            buffTextureRegex14,
            buffTextureRegex15
    );

    return matchesArray, matchedBuffsCount;
end

-- Reads unit's buffs and returns (matchingBuffIndex, matchingBuffTexture) which is the most recently applied buff (highest index) that matched
-- any of the given textures - or nil if no buffs matched
--
-- Note that the matching is exacting and is applied in a case-insensitive manner
--
-- Example usage:
--
--        local matchingBuffIndex, matchingBuffTexture = findMostRecentActiveBuffViaTextures("player", "Interface\\Icons\\Spell_Holy_SealOfWisdom", "Interface\\Icons\\Spell_Holy_SealOfLight", "Interface\\Icons\\Spell_Holy_DevotionAura")
--        if matchingBuffIndex ~= nil then
--            print("** index=" .. matchingBuffIndex .. ", name='" .. matchingBuffTexture .. "'")
--        end
--
function findMostRecentActiveBuffViaTextures(unit, exactBuff1, exactBuff2, exactBuff3, exactBuff4, exactBuff5, exactBuff6, exactBuff7, exactBuff8, exactBuff9, exactBuff10, exactBuff11, exactBuff12, exactBuff13, exactBuff14, exactBuff15)
    local matchesArray, matchedBuffsCount = findActiveBuffsViaTexturesImpl(
            unit,
            true, --   exactMatchingNotRegex = true
            true, --        stopAtFirstMatch = true
            exactBuff1,
            exactBuff2,
            exactBuff3,
            exactBuff4,
            exactBuff5,
            exactBuff6,
            exactBuff7,
            exactBuff8,
            exactBuff9,
            exactBuff10,
            exactBuff11,
            exactBuff12,
            exactBuff13,
            exactBuff14,
            exactBuff15
    );

    if matchedBuffsCount == 0 then
        return nil, nil;
    end

    return matchesArray[1].Index, matchesArray[1].BuffTexture;
end

-- Reads unit's buffs and returns (matchingBuffIndex, matchingBuffTexture) which is the most recently applied buff (highest index) that matched - or nil if no buffs matched
--
-- Note that the regexes are applied in a case-sensitive manner.
--
-- Example usage:
--
--        local matchingBuffIndex, matchingBuffTexture = findMostRecentActiveBuffViaRegexedTextures("player", ".*Spell_Holy_SealOfWisdom$", ".*Spell_Holy_SealOfLight$", ".*Spell_Holy_DevotionAura$")
--        if matchingBuffIndex ~= nil then
--            print("** index=" .. matchingBuffIndex .. ", name='" .. matchingBuffTexture .. "'")
--        end
--
function findMostRecentActiveBuffViaRegexedTextures(unit, buffRegex1, buffRegex2, buffRegex3, buffRegex4, buffRegex5, buffRegex6, buffRegex7, buffRegex8, buffRegex9, buffRegex10, buffRegex11, buffRegex12, buffRegex13, buffRegex14, buffRegex15)
    local matchesArray, matchedBuffsCount = findActiveBuffsViaTexturesImpl(
            unit,
            false, --   exactMatchingNotRegex = false
            true, --         stopAtFirstMatch = true
            buffRegex1,
            buffRegex2,
            buffRegex3,
            buffRegex4,
            buffRegex5,
            buffRegex6,
            buffRegex7,
            buffRegex8,
            buffRegex9,
            buffRegex10,
            buffRegex11,
            buffRegex12,
            buffRegex13,
            buffRegex14,
            buffRegex15
    );

    if matchedBuffsCount == 0 then
        return nil, nil;
    end

    return matchesArray[1].Index, matchesArray[1].BuffTexture;
end

-----------------------------------------------

local function findActiveBuffsImpl(unit, exactMatchingNotRegex, stopAtFirstMatch, buff1, buff2, buff3, buff4, buff5, buff6, buff7, buff8, buff9, buff10, buff11, buff12, buff13, buff14, buff15)
    unit = unit or "player";

    stopAtFirstMatch = stopAtFirstMatch == nil
            and true
            or stopAtFirstMatch;

    exactMatchingNotRegex = exactMatchingNotRegex == nil
            and true
            or exactMatchingNotRegex;

    createTooltipFrame();

    -- print("*********")

    local
    tooltipTextLeft1Tag,
    currentBuffTextbox,
    currentBuffName,
    matchedBuffs,
    matchedBuffsCount,
    currentBuffIsMatching = cernieUsefulFunctionsTooltip:GetName() .. "TextLeft1", nil, nil, nil, 0, false;
    for i = 32, 0, -1 do
        --00 exhaustive search from 32 (most recent buff) down to 0 (oldest buff)

        cernieUsefulFunctionsTooltip:SetOwner(WorldFrame, "ANCHOR_NONE"); --   order
        cernieUsefulFunctionsTooltip:ClearLines();  --                         order
        cernieUsefulFunctionsTooltip:SetUnitBuff(unit, i); --                  order

        currentBuffTextbox = getglobal(tooltipTextLeft1Tag);

        -- print("*****")
        -- print("** i=" .. i .. " -> currentBuffTextbox=" .. _tostring(currentBuffTextbox))

        if currentBuffTextbox ~= nil then
            currentBuffName = currentBuffTextbox:GetText()
            if currentBuffName ~= nil then
                -- print("** i=" .. i .. " -> currentBuffName=" .. _tostring(currentBuffName))

                if exactMatchingNotRegex then
                    currentBuffName = _strlower(currentBuffName);
                    buff1 = buff1 ~= nil and _strlower(buff1) or nil; -- prepare for case-insensitive comparison
                    buff2 = buff2 ~= nil and _strlower(buff2) or nil;
                    buff3 = buff3 ~= nil and _strlower(buff3) or nil;
                    buff4 = buff4 ~= nil and _strlower(buff4) or nil;
                    buff5 = buff5 ~= nil and _strlower(buff5) or nil;
                    buff6 = buff6 ~= nil and _strlower(buff6) or nil;
                    buff7 = buff7 ~= nil and _strlower(buff7) or nil;
                    buff8 = buff8 ~= nil and _strlower(buff8) or nil;
                    buff9 = buff9 ~= nil and _strlower(buff9) or nil;
                    buff10 = buff10 ~= nil and _strlower(buff10) or nil;
                    buff11 = buff11 ~= nil and _strlower(buff11) or nil;
                    buff12 = buff12 ~= nil and _strlower(buff12) or nil;
                    buff13 = buff13 ~= nil and _strlower(buff13) or nil;
                    buff14 = buff14 ~= nil and _strlower(buff14) or nil;
                    buff15 = buff15 ~= nil and _strlower(buff15) or nil;
                end

                currentBuffIsMatching = --@formatter:off
                           (  buff1 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff1 ) or (not exactMatchingNotRegex and _strfind(currentBuffName,  buff1))) )
                        or (  buff2 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff2 ) or (not exactMatchingNotRegex and _strfind(currentBuffName,  buff2))) )
                        or (  buff3 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff3 ) or (not exactMatchingNotRegex and _strfind(currentBuffName,  buff3))) )
                        or (  buff4 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff4 ) or (not exactMatchingNotRegex and _strfind(currentBuffName,  buff4))) )
                        or (  buff5 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff5 ) or (not exactMatchingNotRegex and _strfind(currentBuffName,  buff5))) )
                        or (  buff6 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff6 ) or (not exactMatchingNotRegex and _strfind(currentBuffName,  buff6))) )
                        or (  buff7 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff7 ) or (not exactMatchingNotRegex and _strfind(currentBuffName,  buff7))) )
                        or (  buff8 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff8 ) or (not exactMatchingNotRegex and _strfind(currentBuffName,  buff8))) )
                        or (  buff9 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff9 ) or (not exactMatchingNotRegex and _strfind(currentBuffName,  buff9))) )
                        or ( buff10 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff10) or (not exactMatchingNotRegex and _strfind(currentBuffName, buff10))) )
                        or ( buff11 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff11) or (not exactMatchingNotRegex and _strfind(currentBuffName, buff11))) )
                        or ( buff12 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff12) or (not exactMatchingNotRegex and _strfind(currentBuffName, buff12))) )
                        or ( buff13 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff13) or (not exactMatchingNotRegex and _strfind(currentBuffName, buff13))) )
                        or ( buff14 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff14) or (not exactMatchingNotRegex and _strfind(currentBuffName, buff14))) )
                        or (buff15 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff15) or (not exactMatchingNotRegex and _strfind(currentBuffName, buff15)))); --@formatter:on

                if currentBuffIsMatching then
                    -- print("** [" .. time() .. "] Matching buff found: currentBuffName=" .. _tostring(currentBuffName) .. " at index i=" .. _tostring(i))

                    matchedBuffs = matchedBuffs or {}; -- lazy allocation
                    _tblinsert(matchedBuffs, {
                        Index = i - 1, --  todo  in vanilla-wow we should return 'i-1' but from tbc-wow onwards we should return just 'i' because the APIs for CancelBuff() and so on changed in tbc!
                        BuffName = currentBuffName,
                    });

                    matchedBuffsCount = matchedBuffsCount + 1;

                    if stopAtFirstMatch then
                        break ;
                    end
                end
            end
        end
    end

    if matchedBuffsCount == 0 then
        return nil, 0;
    end

    return matchedBuffs;

    --00  in twow this method sometimes returns nil even if a buff does in fact exist at the given index
    --    we should not get tricked and break out of the loop early in that case
end

-- Reads unit's buffs and returns (matchesArray, matchedBuffsCount) where matchesArray is an array of elements { Index = (number), BuffName = (string) }
-- sorted by descending buff-index (ie: highest buff-index first) or nil if no buffs matched
--
-- Note that string-matching is applied in a case-insensitive manner.
--
-- Example usage:
--
--        local matchedBuffs = findActiveBuffs("player", "Shadow Resistance Aura", "Blessing of Wisdom", "Seal of Wisdom")
--        if matchedBuffs ~= nil then
--            for _, buffInfo in _pairs(matchedBuffs) do
--                print("** index=" .. buffInfo.Index .. ", name='" .. buffInfo.BuffName .. "'")
--            end
--        end
--
function findActiveBuffs(unit, exactBuff1, exactBuff2, exactBuff3, exactBuff4, exactBuff5, exactBuff6, exactBuff7, exactBuff8, exactBuff9, exactBuff10, exactBuff11, exactBuff12, exactBuff13, exactBuff14, exactBuff15)
    local matchesArray, matchedBuffsCount = findActiveBuffsImpl(
            unit,
            true, --   exactMatchingNotRegex = true
            false, --       stopAtFirstMatch = false
            exactBuff1,
            exactBuff2,
            exactBuff3,
            exactBuff4,
            exactBuff5,
            exactBuff6,
            exactBuff7,
            exactBuff8,
            exactBuff9,
            exactBuff10,
            exactBuff11,
            exactBuff12,
            exactBuff13,
            exactBuff14,
            exactBuff15
    );

    return matchesArray, matchedBuffsCount;
end

-- Reads unit's buffs and returns (matchesArray, matchedBuffsCount) where matchesArray is an array of elements { Index = (number), BuffName = (string) }
-- sorted by descending buff-index (ie: highest buff-index first) or nil if no buffs matched
--
-- Note that the regexes are applied in a case-sensitive manner (this behaviour is different from the legacy isBuffNameActive() which was case-insensitive)
--
-- Example usage:
--
--        local matchedBuffs = findRegexedActiveBuffs("player", ".* Resistance Aura", "Blessing of .*", "Seal of .*")
--        if matchedBuffs ~= nil then
--            for _, buffInfo in _pairs(matchedBuffs) do
--                print("** index=" .. buffInfo.Index .. ", name='" .. buffInfo.BuffName .. "'")
--            end
--        end
--
function findRegexedActiveBuffs(unit, buffRegex1, buffRegex2, buffRegex3, buffRegex4, buffRegex5, buffRegex6, buffRegex7, buffRegex8, buffRegex9, buffRegex10, buffRegex11, buffRegex12, buffRegex13, buffRegex14, buffRegex15)
    local matchesArray, matchedBuffsCount = findActiveBuffsImpl(
            unit,
            false, -- exactMatchingNotRegex = false
            false, --      stopAtFirstMatch = false
            buffRegex1,
            buffRegex2,
            buffRegex3,
            buffRegex4,
            buffRegex5,
            buffRegex6,
            buffRegex7,
            buffRegex8,
            buffRegex9,
            buffRegex10,
            buffRegex11,
            buffRegex12,
            buffRegex13,
            buffRegex14,
            buffRegex15
    );

    return matchesArray, matchedBuffsCount;
end

-- Reads unit's buffs and returns (matchingBuffIndex, matchingBuffName) which is the most recently applied buff (highest index) that matched - or nil if no buffs matched
--
-- Note that the matching is exacting and is applied in a case-insensitive manner
--
-- Example usage:
--
--        local matchingBuffIndex, matchingBuffName = findMostRecentActiveBuff("player", "Shadow Resistance Aura", "Blessing of Wisdom")
--        if matchingBuffIndex ~= nil then
--            print("** index=" .. matchingBuffIndex .. ", name='" .. matchingBuffName .. "'")
--        end
--
function findMostRecentActiveBuff(unit, exactBuff1, exactBuff2, exactBuff3, exactBuff4, exactBuff5, exactBuff6, exactBuff7, exactBuff8, exactBuff9, exactBuff10, exactBuff11, exactBuff12, exactBuff13, exactBuff14, exactBuff15)
    local matchesArray, matchedBuffsCount = findActiveBuffsImpl(
            unit,
            true, --    exactMatchingNotRegex = true
            true, --         stopAtFirstMatch = true
            exactBuff1,
            exactBuff2,
            exactBuff3,
            exactBuff4,
            exactBuff5,
            exactBuff6,
            exactBuff7,
            exactBuff8,
            exactBuff9,
            exactBuff10,
            exactBuff11,
            exactBuff12,
            exactBuff13,
            exactBuff14,
            exactBuff15
    );

    if matchedBuffsCount == 0 then
        return nil, nil;
    end

    return matchesArray[1].Index, matchesArray[1].BuffName;
end

-- Reads unit's buffs and returns (matchingBuffIndex, matchingBuffName) which is the most recently applied buff (highest index) that matched - or nil if no buffs matched
--
-- Note that the regexes are applied in a case-sensitive manner (this behaviour is different from the legacy isBuffNameActive() which was case-insensitive)
--
-- Example usage:
--
--        local matchingBuffIndex, matchingBuffName = findMostRecentRegexedActiveBuff("player", ".* Resistance Aura", "Blessing of .*", "Seal of .*")
--        if matchingBuffIndex ~= nil then
--            print("** index=" .. matchingBuffIndex .. ", name='" .. matchingBuffName .. "'")
--        end
--
function findMostRecentRegexedActiveBuff(unit, buffRegex1, buffRegex2, buffRegex3, buffRegex4, buffRegex5, buffRegex6, buffRegex7, buffRegex8, buffRegex9, buffRegex10, buffRegex11, buffRegex12, buffRegex13, buffRegex14, buffRegex15)
    local matchesArray, matchedBuffsCount = findActiveBuffsImpl(
            unit,
            false, --   exactMatchingNotRegex = false
            true, --         stopAtFirstMatch = true
            buffRegex1,
            buffRegex2,
            buffRegex3,
            buffRegex4,
            buffRegex5,
            buffRegex6,
            buffRegex7,
            buffRegex8,
            buffRegex9,
            buffRegex10,
            buffRegex11,
            buffRegex12,
            buffRegex13,
            buffRegex14,
            buffRegex15
    );

    if matchedBuffsCount == 0 then
        return nil, nil;
    end

    return matchesArray[1].Index, matchesArray[1].BuffName;
end

function CastSpellIfSpecifiedBuffsAreAllMissing(scanUnit, spell, onSelf, useStopCastingFirst, buff1, buff2, buff3, buff4, buff5, buff6, buff7, buff8, buff9, buff10, buff11, buff12, buff13, buff14, buff15)
    buff1 = buff1 or spell; -- if buff1 is not specified, assume the buff to check for is the same as the spell to cast

    local mostRecentBuffIndex = findMostRecentActiveBuff(scanUnit, buff1, buff2, buff3, buff4, buff5, buff6, buff7, buff8, buff9, buff10, buff11, buff12, buff13, buff14, buff15);
    if mostRecentBuffIndex ~= nil then
        return false; -- at least one buff found, do not cast
    end

    if useStopCastingFirst then
        SpellStopCasting();
    end

    onSelf = onSelf == nil
            and true
            or onSelf;

    CastSpellByName(spell, onSelf)

    return true
end

function CastSpellIfSpecifiedRegexedBuffsAreAllMissing(scanUnit, spell, onSelf, useStopCastingFirst, buffRegex1, buffRegex2, buffRegex3, buffRegex4, buffRegex5, buffRegex6, buffRegex7, buffRegex8, buffRegex9, buffRegex10, buffRegex11, buffRegex12, buffRegex13, buffRegex14, buffRegex15)
    buffRegex1 = buffRegex1 or spell; -- if buff1 is not specified, assume the buff to check for is the same as the spell to cast

    local mostRecentBuffIndex = findMostRecentRegexedActiveBuff(scanUnit, buffRegex1, buffRegex2, buffRegex3, buffRegex4, buffRegex5, buffRegex6, buffRegex7, buffRegex8, buffRegex9, buffRegex10, buffRegex11, buffRegex12, buffRegex13, buffRegex14, buffRegex15);
    if mostRecentBuffIndex ~= nil then
        return false; -- at least one buff found, do not cast
    end

    if useStopCastingFirst then
        SpellStopCasting();
    end

    onSelf = onSelf == nil
            and true
            or onSelf;

    CastSpellByName(spell, onSelf);

    return true;
end

function CastSpellIfAnySpecifiedBuffIsPresent(scanUnit, spell, onSelf, useStopCastingFirst, buff1, buff2, buff3, buff4, buff5, buff6, buff7, buff8, buff9, buff10, buff11, buff12, buff13, buff14, buff15)
    buff1 = buff1 or spell; -- if buff1 is not specified, assume the buff to check for is the same as the spell to cast

    local mostRecentBuffIndex = findMostRecentActiveBuff(scanUnit, buff1, buff2, buff3, buff4, buff5, buff6, buff7, buff8, buff9, buff10, buff11, buff12, buff13, buff14, buff15);
    if mostRecentBuffIndex == nil then
        return false; -- none of the specified buffs was found
    end

    if useStopCastingFirst then
        SpellStopCasting();
    end

    onSelf = onSelf == nil
            and true
            or onSelf;

    CastSpellByName(spell, onSelf);

    return true;
end

function CastSpellIfAnySpecifiedRegexedBuffIsPresent(scanUnit, spell, onSelf, useStopCastingFirst, buffRegex1, buffRegex2, buffRegex3, buffRegex4, buffRegex5, buffRegex6, buffRegex7, buffRegex8, buffRegex9, buffRegex10, buffRegex11, buffRegex12, buffRegex13, buffRegex14, buffRegex15)
    buffRegex1 = buffRegex1 or spell; -- if buff1 is not specified, assume the buff to check for is the same as the spell to cast

    local mostRecentBuffIndex = findMostRecentRegexedActiveBuff(scanUnit, buffRegex1, buffRegex2, buffRegex3, buffRegex4, buffRegex5, buffRegex6, buffRegex7, buffRegex8, buffRegex9, buffRegex10, buffRegex11, buffRegex12, buffRegex13, buffRegex14, buffRegex15)
    if mostRecentBuffIndex == nil then
        return false; -- none of the specified buffs was found
    end

    if useStopCastingFirst then
        SpellStopCasting();
    end

    onSelf = onSelf == nil
            and true
            or onSelf;

    CastSpellByName(spell, onSelf);

    return true;
end

local _lastCancelPlayerBuffTimestamp = 0;

local function cancelPlayerBuffByNamesOrTexturesImpl(useNamesNotTextures, useExactMatchingNotRegexes, throttlingTimeInSeconds, buffString1, buffString2, buffString3, buffString4, buffString5, buffString6, buffString7, buffString8, buffString9, buffString10, buffString11, buffString12, buffString13, buffString14, buffString15)
    useNamesNotTextures = useNamesNotTextures == nil
            and true
            or useNamesNotTextures;

    throttlingTimeInSeconds = (throttlingTimeInSeconds == nil or throttlingTimeInSeconds < 0)
            and 1 -- default to 1 seconds
            or throttlingTimeInSeconds;

    local now = time();
    if now - _lastCancelPlayerBuffTimestamp < throttlingTimeInSeconds then
        return false; -- throttled
    end

    local matchingBuffIndex

    if useNamesNotTextures then
        -- buff-name-based filtering
        if useExactMatchingNotRegexes then
            -- dont turn this into ternary as it will break if the first find returns nil!
            matchingBuffIndex = findMostRecentActiveBuff("player", buffString1, buffString2, buffString3, buffString4, buffString5, buffString6, buffString7, buffString8, buffString9, buffString10, buffString11, buffString12, buffString13, buffString14, buffString15)
        else
            matchingBuffIndex = findMostRecentRegexedActiveBuff("player", buffString1, buffString2, buffString3, buffString4, buffString5, buffString6, buffString7, buffString8, buffString9, buffString10, buffString11, buffString12, buffString13, buffString14, buffString15)
        end
    else
        -- buff-texture-based filtering
        if useExactMatchingNotRegexes then
            -- dont turn this into ternary as it will break if the first find returns nil!
            matchingBuffIndex = findMostRecentActiveBuffViaTextures("player", buffString1, buffString2, buffString3, buffString4, buffString5, buffString6, buffString7, buffString8, buffString9, buffString10, buffString11, buffString12, buffString13, buffString14, buffString15)
        else
            matchingBuffIndex = findMostRecentActiveBuffViaRegexedTextures("player", buffString1, buffString2, buffString3, buffString4, buffString5, buffString6, buffString7, buffString8, buffString9, buffString10, buffString11, buffString12, buffString13, buffString14, buffString15)
        end
    end

    if matchingBuffIndex == nil then
        return false;
    end

    _lastCancelPlayerBuffTimestamp = now;

    CancelPlayerBuff(matchingBuffIndex); --00

    return true;

    -- 00  its prudent to cancel one buff at a time because there are known issues whereby spamming cancel-buff commands
    --     can cause the client to desync and either not cancel the buff at all or start canceling the wrong buffs altogether!
end

function CancelPlayerBuffByName(throttlingTimeInSeconds, exactBuff1, exactBuff2, exactBuff3, exactBuff4, exactBuff5, exactBuff6, exactBuff7, exactBuff8, exactBuff9, exactBuff10, exactBuff11, exactBuff12, exactBuff13, exactBuff14, exactBuff15)
    return cancelPlayerBuffByNamesOrTexturesImpl(
            true, --   useNamesNotTextures        = true
            true, --   useExactMatchingNotRegexes = true
            throttlingTimeInSeconds,
            exactBuff1, exactBuff2, exactBuff3, exactBuff4, exactBuff5, exactBuff6, exactBuff7,
            exactBuff8, exactBuff9, exactBuff10, exactBuff11, exactBuff12, exactBuff13, exactBuff14, exactBuff15
    );
end

function CancelPlayerBuffByRegexedName(throttlingTimeInSeconds, regexedBuff1, regexedBuff2, regexedBuff3, regexedBuff4, regexedBuff5, regexedBuff6, regexedBuff7, regexedBuff8, regexedBuff9, regexedBuff10, regexedBuff11, regexedBuff12, regexedBuff13, regexedBuff14, regexedBuff15)
    return cancelPlayerBuffByNamesOrTexturesImpl(
            true, --    useNamesNotTextures        = true
            false, --   useExactMatchingNotRegexes = false
            throttlingTimeInSeconds,
            regexedBuff1, regexedBuff2, regexedBuff3, regexedBuff4, regexedBuff5, regexedBuff6, regexedBuff7,
            regexedBuff8, regexedBuff9, regexedBuff10, regexedBuff11, regexedBuff12, regexedBuff13, regexedBuff14, regexedBuff15
    );
end

----------------------------------------------------------------

-- Cancels the most recently applied buff on the player that matches any of the given texture-strings
-- (eg: "Interface\\Icons\\Spell_Holy_SealOfWisdom") using case-insensitive full-string-matching
function CancelPlayerBuffViaTextures(throttlingTimeInSeconds, texture1, texture2, texture3, texture4, texture5, texture6, texture7, texture8, texture9, texture10, texture11, texture12, texture13, texture14, texture15)
    return cancelPlayerBuffByNamesOrTexturesImpl(
            false, --   useNamesNotTextures        = false
            true, --    useExactMatchingNotRegexes = true
            throttlingTimeInSeconds,
            texture1, texture2, texture3, texture4, texture5, texture6, texture7,
            texture8, texture9, texture10, texture11, texture12, texture13, texture14, texture15
    );
end

-- Cancels the most recently applied buff on the player that matches any of the given texture-regexes
-- (eg: "Interface\\Icons\\Spell_Holy_SealOfWisdom") using case-sensitive regex-matching
function CancelPlayerBuffViaRegexedTextures(throttlingTimeInSeconds, regexedTexture1, regexedTexture2, regexedTexture3, regexedTexture4, regexedTexture5, regexedTexture6, regexedTexture7, regexedTexture8, regexedTexture9, regexedTexture10, regexedTexture11, regexedTexture12, regexedTexture13, regexedTexture14, regexedTexture15)
    return cancelPlayerBuffByNamesOrTexturesImpl(
            false, --   useNamesNotTextures        = false
            false, --   useExactMatchingNotRegexes = false
            throttlingTimeInSeconds,
            regexedTexture1, regexedTexture2, regexedTexture3, regexedTexture4, regexedTexture5, regexedTexture6, regexedTexture7,
            regexedTexture8, regexedTexture9, regexedTexture10, regexedTexture11, regexedTexture12, regexedTexture13, regexedTexture14, regexedTexture15
    );
end

----------------------------------------------------------------

local PALADIN__IMMUNITIES__TEXTURES_EXACT_FILEPATHS = {
    "interface\\icons\\spell_holy_divineintervention", -- Divine Shield
    "interface\\icons\\spell_holy_restoration", --        Divine Protection
    "interface\\icons\\spell_holy_sealofprotection", --   Blessing/Hand of Protection
    "interface\\icons\\spell_nature_timestop" --          Divine Intervention    
};

local PALADIN__IMMUNITIES__TEXTURES_FILENAMES_REGEXES = {
    "[Ss][Pp][Ee][Ll].*[Hh][Oo][Ll][Yy].*[Rr][Ee][Ss][Tt][Oo][Rr][Aa][Tt][Ii][Oo][Nn]$", --                                 Divine Protection
    "[Ss][Pp][Ee][Ll].*[Hh][Oo][Ll][Yy].*[Dd][Ii][Vv][Ii][Nn][Ee].*[Ii][Nn][Tt][Ee][Rr][Vv][Ee][Nn][Tt][Ii][Oo][Nn]$", --   Divine Shield
    "[Ss][Pp][Ee][Ll].*[Hh][Oo][Ll][Yy].*[Ss][Ee][Aa][Ll].*[Oo][Ff].*[Pp][Rr][Oo][Tt][Ee][Cc][Tt][Ii][Oo][Nn]$", --         Blessing/Hand of Protection
    "[Ss][Pp][Ee][Ll].*[Nn][Aa][Tt][Uu][Rr][Ee].*[Tt][Ii][Mm][Ee][Ss][Tt][Oo][Pp]$" --                                      Divine Intervention
};

-- Cancels common paladin immunities (Divine Protection, Divine Intervention, Blessing of Protection, etc)
-- returns true if any of the associated buffs was found, false otherwise
function CancelPaladinImmunities(throttlingTimeInSeconds)
    -- @formatter:off
    return CancelPlayerBuffViaTextures( -- fast path
                  throttlingTimeInSeconds,
                  PALADIN__IMMUNITIES__TEXTURES_EXACT_FILEPATHS[1],
                  PALADIN__IMMUNITIES__TEXTURES_EXACT_FILEPATHS[2],
                  PALADIN__IMMUNITIES__TEXTURES_EXACT_FILEPATHS[3],
                  PALADIN__IMMUNITIES__TEXTURES_EXACT_FILEPATHS[4],
                  PALADIN__IMMUNITIES__TEXTURES_EXACT_FILEPATHS[5],
                  PALADIN__IMMUNITIES__TEXTURES_EXACT_FILEPATHS[6],
                  PALADIN__IMMUNITIES__TEXTURES_EXACT_FILEPATHS[7],
                  PALADIN__IMMUNITIES__TEXTURES_EXACT_FILEPATHS[8],
                  PALADIN__IMMUNITIES__TEXTURES_EXACT_FILEPATHS[9],
                  PALADIN__IMMUNITIES__TEXTURES_EXACT_FILEPATHS[10]
           )
           or
           CancelPlayerBuffViaRegexedTextures( -- fallback just in case some wowclients have different texture-paths
                  throttlingTimeInSeconds,
                  PALADIN__IMMUNITIES__TEXTURES_FILENAMES_REGEXES[1],
                  PALADIN__IMMUNITIES__TEXTURES_FILENAMES_REGEXES[2],
                  PALADIN__IMMUNITIES__TEXTURES_FILENAMES_REGEXES[3],
                  PALADIN__IMMUNITIES__TEXTURES_FILENAMES_REGEXES[4],
                  PALADIN__IMMUNITIES__TEXTURES_FILENAMES_REGEXES[5],
                  PALADIN__IMMUNITIES__TEXTURES_FILENAMES_REGEXES[6],
                  PALADIN__IMMUNITIES__TEXTURES_FILENAMES_REGEXES[7],
                  PALADIN__IMMUNITIES__TEXTURES_FILENAMES_REGEXES[8],
                  PALADIN__IMMUNITIES__TEXTURES_FILENAMES_REGEXES[9],
                  PALADIN__IMMUNITIES__TEXTURES_FILENAMES_REGEXES[10]
           )
    -- @formatter:off
end

local PALADIN__RIGHTEOUS_FURY__TEXTURE_FILEPATH = "interface\\icons\\spell_holy_sealoffury";
local PALADIN__RIGHTEOUS_FURY__TEXTURE_FILENAME_REGEX = "[Ss][Pp][Ee][Ll][Ll].*[Hh][Oo][Ll][Yy].*[Ss][Ee][Aa][Ll].*[Oo][Ff].*[Ff][Uu][Rr][Yy]$"; -- spell_holy_sealoffury

-- Cancels paladin righteous fury buff
local _preferredMethodForCancellingRighteousFury; -- nil = still undecided, true = prefer exact texture-path matching, false = prefer regexed texture-path matching
function CancelPaladinRighteousFury(throttlingTimeInSeconds) --@formatter:off
    local cancelledViaExactTexturePath        = (_preferredMethodForCancellingRighteousFury == nil or     _preferredMethodForCancellingRighteousFury) and CancelPlayerBuffViaTextures(throttlingTimeInSeconds, PALADIN__RIGHTEOUS_FURY__TEXTURE_FILEPATH) ~= nil;
    local cancelledViaExactRegexedTexturePath = (_preferredMethodForCancellingRighteousFury == nil or not _preferredMethodForCancellingRighteousFury) and CancelPlayerBuffViaRegexedTextures(throttlingTimeInSeconds, PALADIN__RIGHTEOUS_FURY__TEXTURE_FILENAME_REGEX) ~= nil;

    if _preferredMethodForCancellingRighteousFury == nil and (cancelledViaExactTexturePath or cancelledViaExactRegexedTexturePath) then
        -- at least one of the two methods found the buff   this is a tellsign that we should only prefer one of the two methods from
        -- now on we prefer exact texture-path matching if it worked (most common)   otherwise prefer regexed texture-path matching
        _preferredMethodForCancellingRighteousFury = cancelledViaExactTexturePath;
    end

    return cancelledViaExactTexturePath or cancelledViaExactRegexedTexturePath;
end --@formatter:on

local function tryGetLocalizedSpellNameFor_paladinRighteousFury()
    _paladin__righteousFury__localizedSpellName = _paladin__righteousFury__localizedSpellName
            or tryGetLocalizedSpellNameByRegexedTextureFilePath(PALADIN__RIGHTEOUS_FURY__TEXTURE_FILENAME_REGEX)
            or ""; -- paladin too low level or not a paladin at all

    return _paladin__righteousFury__localizedSpellName ~= ""
            and _paladin__righteousFury__localizedSpellName
            or nil;
end

-- Ensures paladin righteous fury buff is active, returns true if it was off and got cast, false if it was already on
function EnsurePaladinRighteousFuryIsOn()
    local localizedSpellName = tryGetLocalizedSpellNameFor_paladinRighteousFury();
    if not localizedSpellName then
        return false; -- cant find the spell   not a paladin or too low level paladin
    end

    local isAlreadyOn = findMostRecentActiveBuffViaRegexedTextures("player", PALADIN__RIGHTEOUS_FURY__TEXTURE_FILENAME_REGEX) ~= nil;
    if isAlreadyOn then
        return false;
    end

    CastSpellByName(localizedSpellName, true);
    return true;
end

----------------------------------------------------------------

local WEAPON__EDWARD_THE_ODD__BUFF_PROC__TEXTURE_FILEPATH = "interface\\icons\\spell_holy_searinglight"; -- todo  add regexed version too?

function isEdwardTheOddBuffProcced()
    return findMostRecentActiveBuffViaTextures("player", WEAPON__EDWARD_THE_ODD__BUFF_PROC__TEXTURE_FILEPATH) ~= nil;
end

----------------------------------------------------------------

local _havePrintedDeprecationWarningFor_isBuffNameActive = false;

--[DEPRECATED: Use findRegexedActiveBuffs() instead] Reads unit's buffs and returns isBuffActive, buffIndex, numBuffs
function isBuffNameActive(buff, unit)
    if not _havePrintedDeprecationWarningFor_isBuffNameActive then
        _printDeprecationWarning(TF("Function '%s()' has been deprecated - use '%s()' instead!", "isBuffNameActive", "findRegexedActiveBuffs"));
        _havePrintedDeprecationWarningFor_isBuffNameActive = true;
    end

    unit = unit or "player";

    createTooltipFrame();

    local i = 1;
    local g = UnitBuff;
    local buffIndex = -1;
    local isBuffActive = false;

    local numBuffs, textleft1;
    while not (g(unit, i) == -1 or g(unit, i) == nil)
    do
        cernieUsefulFunctionsTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
        cernieUsefulFunctionsTooltip:ClearLines();
        cernieUsefulFunctionsTooltip:SetUnitBuff(unit, i);
        textleft1 = getglobal(cernieUsefulFunctionsTooltip:GetName() .. "TextLeft1");

        if (textleft1 ~= nil and _strfind(_strlower(textleft1:GetText()), _strlower(buff))) then
            isBuffActive = true;
            buffIndex = i - 1;
        end
        cernieUsefulFunctionsTooltip:Hide();
        i = i + 1;
    end

    numBuffs = i - 1;
    return isBuffActive, buffIndex, numBuffs;
end

--Reads unit's debuffs and returns isDebuffActive, debuffIndex, numDebuffs
function isDebuffNameActive(debuff, unit)
    unit = unit or "player";

    createTooltipFrame();

    local i = 1;
    local g = UnitDebuff;
    local debuffIndex = -1;
    local isDebuffActive = false;

    local textleft1;
    local numDebuffs;
    while not (g(unit, i) == -1 or g(unit, i) == nil)
    do
        cernieUsefulFunctionsTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
        cernieUsefulFunctionsTooltip:ClearLines();
        cernieUsefulFunctionsTooltip:SetUnitDebuff(unit, i);
        textleft1 = getglobal(cernieUsefulFunctionsTooltip:GetName() .. "TextLeft1");

        if (textleft1 ~= nil and _strfind(_strlower(textleft1:GetText()), _strlower(debuff))) then
            isDebuffActive = true;
            debuffIndex = i - 1;
        end
        cernieUsefulFunctionsTooltip:Hide();
        i = i + 1;
    end

    numDebuffs = i - 1;

    return isDebuffActive, debuffIndex, numDebuffs;
end

--find auto attack, returns action slot id (0 if not found)
function findAttackActionSlot()
    for i = 1, 120, 1
    do
        if (IsAttackAction(i) == 1 and IsCurrentAction(i) == 1) then
            return i;
        end
    end
    return 0;
end

--find auto ranged attack, returns action slot id (0 if not found)
function findAutoRangedActionSlot()
    for i = 1, 120, 1
    do
        if (IsAutoRepeatAction(i) == 1) then
            return i;
        end
    end
    return 0;
end

--find a debuff on target, returns true or false
function isTargetDebuff(target, debuff)
    local isDebuff = false;
    for i = 1, 40
    do
        if (_strfind(_tostring(UnitDebuff(target, i)), debuff)) then
            isDebuff = true;
        end
    end
    return isDebuff;
end

--Cast a spell based on modifiers
function ModifySpellAction(options)
    local shiftDown = IsShiftKeyDown();
    local ctrlDown = IsControlKeyDown();
    local altDown = IsAltKeyDown();
    local cast = CastSpellByName;

    if (shiftDown and options.shift ~= nil) then
        cast(options.shift);
    elseif (ctrlDown and options.ctrl ~= nil) then
        cast(options.ctrl);
    elseif (altDown and options.alt ~= nil) then
        cast(options.alt);
    elseif (options.unmod ~= nil) then
        cast(options.unmod);
    end
end

--Use a script based on modifiers. This is more generic than ModifySpellAction but requires more input.
function ModifyKeyAction(options)
    local shiftDown = IsShiftKeyDown();
    local ctrlDown = IsControlKeyDown();
    local altDown = IsAltKeyDown();

    if (shiftDown and options.shift ~= nil) then
        RunScript(options.shift);
    elseif (ctrlDown and options.ctrl ~= nil) then
        RunScript(options.ctrl);
    elseif (altDown and options.alt ~= nil) then
        RunScript(options.alt);
    elseif (options.unmod ~= nil) then
        RunScript(options.unmod);
    end
end

--Uses your normal mount or AQ40 mount if inside AQ40
local ZONES_AQ40 = {
    [L "Ahn'Qiraj"] = true,
    [L "Temple of Ahn'Qiraj"] = true,
};

function MountAQ(normal, aq)
    local localizedZoneName = GetRealZoneText(); -- get the localized zone-name
    if ZONES_AQ40[localizedZoneName] then
        local aqMountsToTry = {
            [1] = L(aq or ""),
            [2] = L "Black Qiraji Battle Tank",
            [3] = L "Red Qiraji Battle Tank",
            [4] = L "Blue Qiraji Battle Tank",
            [5] = L "Green Qiraji Battle Tank",
            [6] = L "Yellow Qiraji Battle Tank"
        };

        for __, aqMount in _ipairs(aqMountsToTry) do
            if aqMount ~= "" then
                if haveSpell(aqMount) then
                    -- in twow the mounts are actually stored as spells and not as items like in vwow
                    CastSpellByName(aqMount, true);
                    return true;
                end
            end
        end

        for __, aqMount in _ipairs(aqMountsToTry) do
            if aqMount ~= "" then
                local aqFound, aqBag, aqSlot = isInBag(aqMount);
                if (aqFound) then
                    UseContainerItem(aqBag, aqSlot, 1);
                    return true;
                end
            end
        end
        return true;
    end

    if haveSpell(normal) then
        -- paladin mounts are spells and not items   moreover in twow all mounts are spells
        CastSpellByName(normal, true);
        return true;
    end

    local normalFound, normalBag, normalSlot = isInBag(normal); -- vanilla wow mounts are items
    if (normalFound) then
        UseContainerItem(normalBag, normalSlot, 1);
        return true;
    end
    
    return false;
end

--Uses a container item based on item-name-regex, self ensures the item is used on the player
function UseItemInBag(itemNameRegex, useOnSelf)
    useOnSelf = useOnSelf or 0

    local found, bag, slot = isInBag(itemNameRegex)
    if not found then
        return false
    end

    UseContainerItem(bag, slot, useOnSelf)
    return true
end


-- Function to determine if spell or ability is on Cooldown, returns true or false. (For experimental mode that checks the cd based on your latency: uncomment the commented lines, and comment out the last return line)
function isSpellOnCd(spell)
    local _, _, latency = GetNetStats();
    local _, duration, _ = GetSpellCooldown(getSpellId(spell), BOOKTYPE_SPELL);

    latency = latency / 1000;

    return (duration > latency);
end

--Function to determine if a container item is on Cooldown, returns true or false
function isContainerItemOnCd(itemName)
    local found, bag, slot = isInBag(itemName);

    local isOnCd, start, duration, enabled;
    if (found) then
        start, duration, enabled = GetContainerItemCooldown(bag, slot);
        if (enabled ~= 1 or (enabled == 1 and duration == 0)) then
            isOnCd = false;
        elseif (enabled == 1 and duration ~= 0) then
            isOnCd = true;
        end
    end
    return isOnCd;
end

--Helper function to find the action slot id based on texture
function findActionSlot(spellTexture)
    for i = 1, 120, 1
    do
        if (GetActionTexture(i) ~= nil) then
            if (_strfind(GetActionTexture(i), spellTexture)) then
                return i;
            end
        end
    end
    return 0;
end

--Function to toggle auto attack "on" or "off"
function ToggleAutoAttack(switch)
    if (switch == "off") then
        if (findAttackActionSlot() ~= 0) then
            AttackTarget();
        end
    elseif (switch == "on") then
        if (findAttackActionSlot() == 0) then
            AttackTarget();
        end
    end
end

--Helper function to determine if an item is in the player's bags, returns boolean of if found and bag and slot ids
function isInBag(itemNameRegex)
    local found = false;
    local itemBag, itemSlot;
    for bag = 0, 4, 1 do
        for slot = 1, GetContainerNumSlots(bag), 1 do
            local name = getItemName(GetContainerItemLink(bag, slot))
            if name and _strfind(name, itemNameRegex) == 1 then
                found = true;
                itemBag = bag;
                itemSlot = slot;
                return found, itemBag, itemSlot;
            end
        end
    end

    return found, itemBag, itemSlot;
end

local BRACKET_END = "]";
local BRACKET_START = "|h";

--Helper function to get an item name given an item link
function getItemName(itemLink)
    if itemLink == nil then
        return nil
    end

    return _strsub(
            itemLink,
            _strfind(itemLink, BRACKET_START, 1, true) + 3,
            _strfind(itemLink, BRACKET_END, 1, true) - 1
    );
end

--Helper function to determine if a specific buff texture is active on the player
function isBuffTextureActive(textureRegex)
    local g = GetPlayerBuff;
    local buffIndex = -1;
    local isBuffActive = false;

    for buffId = 32, 0, -1 do
        -- prefer exhaustive reverse search    in twow we need to also scan buffId=0 despite what the docs say about buffId being 1..16
        buffIndex = g(buffId)
        if buffIndex ~= nil and buffIndex >= 0 and _strfind(GetPlayerBuffTexture(buffIndex) or "", textureRegex) then
            return true, buffId;
        end
    end

    return false, -1;
end

--Helper function for a user to determine buff texture names
function printBuffTextures()
    local g = GetPlayerBuff;
    local buffIndex;

    for buffId = 0, 32, 1 do
        -- in twow we need to also scan buffId=0 despite what the docs say about buffId being 1..16
        buffIndex = g(buffId);
        if buffIndex ~= nil and buffIndex >= 0 then
            -- prefer exhaustive scanning
            local fullTexturePath = GetPlayerBuffTexture(buffIndex) or "";
            local textureFileName = _strsplit(fullTexturePath, "Icons\\")[2] or "nil";
            _print("buffId=" .. _tostring(buffId) .. " (buffIndex=" .. _tostring(buffIndex) .. "): " .. _tostring(textureFileName) .. ", fullPath=" .. _tostring(fullTexturePath));
        end
    end
end
