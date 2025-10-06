CerniesWonderfulFunctions = {};
CWF_isPlayerInCombat = false;

local _tostring = tostring

local _strsub = string.sub
local _strfind = string.find
local _strlower = string.lower

local _getn = table.getn
local _tblinsert = table.insert

--Function to split a string
function _strsplit(self, delimiter)
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

function CerniesWonderfulFunctions_OnLoad()
    this:RegisterEvent("PLAYER_LOGIN")
    this:RegisterEvent("PLAYER_REGEN_DISABLED")
    this:RegisterEvent("PLAYER_REGEN_ENABLED")
    local msg = "Cernie's Wonderful Functions (CWF) loaded. Please see the readme for instructions.";
    DEFAULT_CHAT_FRAME:AddMessage(msg);
end

function CerniesWonderfulFunctions_OnEvent(event)
    if (event == "PLAYER_REGEN_DISABLED") then
        CWF_isPlayerInCombat = true;
    elseif (event == "PLAYER_REGEN_ENABLED") then
        CWF_isPlayerInCombat = false;
    end
end

function UseBestBandage()
    UseBGBandage(
            "Warsong Gulch Runecloth Bandage",
            "Arathi Basin Runecloth Bandage",
            "Alterac Heavy Runecloth Bandage",
            "Heavy Runecloth Bandage",
            "Runecloth Bandage",
            "Heavy Mageweave Bandage",
            "Mageweave Bandage",
            "Heavy Silk Bandage",
            "Silk Bandage",
            "Heavy Linen Bandage",
            "Linen Bandage",
            "Heavy Wool Bandage",
            "Wool Bandage"
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
    local zone = GetRealZoneText();
    local wgFound, wgBag, wgSlot = isInBag(wg);
    local abFound, abBag, abSlot = isInBag(ab);
    local avFound, avBag, avSlot = isInBag(av);

    if (zone == "Warsong Gulch" and wgFound == true) then
        UseContainerItem(wgBag, wgSlot);
        msg = wg;
    elseif (zone == "Alterac Valley" and avFound == true) then
        UseContainerItem(avBag, avSlot);
        msg = av;
    elseif (zone == "Arathi Basin" and abFound == true) then
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
                break;
            end
        end

        if msg == nil then
            msg = "Nothing";
        end
    end

    DEFAULT_CHAT_FRAME:AddMessage("CWF: Attempting to use " .. msg .. "!");
end

--One action for using Battleground specific biscuits instead of regular food/water
function UseBGBiscuit(wg, ab, av)
    --'Warsong Gulch Enriched Ration''Alterac Manna Biscuit''Arathi Basin Enriched Ration'
    local zone = GetRealZoneText();
    local msg;
    local wgFound, wgBag, wgSlot = isInBag(wg);
    local abFound, abBag, abSlot = isInBag(ab);
    local avFound, avBag, avSlot = isInBag(av);

    if (zone == "Warsong Gulch" and wgFound == true) then
        UseContainerItem(wgBag, wgSlot);
        msg = wg;
    elseif (zone == "Alterac Valley" and avFound == true) then
        UseContainerItem(avBag, avSlot);
        msg = av;
    elseif (zone == "Arathi Basin" and abFound == true) then
        UseContainerItem(abBag, abSlot);
        msg = ab;
    elseif (avFound == true) then
        UseContainerItem(avBag, avSlot);
        msg = av;
    else
        msg = "Nothing";
    end

    DEFAULT_CHAT_FRAME:AddMessage("CWF: Attempting to use " .. msg .. "!");
end

--One action for drinking and eating, press twice to do both
function Nom(water, food)
    local waterFound, waterBag, waterSlot = isInBag(water);
    local foodFound, foodBag, foodSlot = isInBag(food);
    local healthPct = UnitHealth("player") / UnitHealthMax("player");
    local manaPct = UnitMana("player") / UnitManaMax("player");

    if (CWF_isPlayerInCombat == false) then
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

    if (CWF_isPlayerInCombat == false) then
        if (isBuffNameActive("Food") == false and foodFound == true and healthPct ~= 1) then
            UseContainerItem(foodBag, foodSlot, 1);
        end
    end
end

--One action for drinking for mana using classes
function NomWater(water)
    local waterFound, waterBag, waterSlot = isInBag(water);
    local manaPct = UnitMana("player") / UnitManaMax("player");

    if (CWF_isPlayerInCombat == false) then
        if (isBuffNameActive("Drink") == false and waterFound == true and manaPct ~= 1) then
            UseContainerItem(waterBag, waterSlot, 1);
        end
    end
end

--One action to use a Mana potion based on location and item availability
function UseManaPotion()
    local potion = { 'Major Mana Draught', 'Major Mana Potion', 'Combat Mana Potion', 'Wildvine Potion', 'Superior Mana Potion', 'Greater Mana Potion', 'Mana Potion', 'Lesser Mana Potion', 'Minor Mana Potion' };
    local zone = GetRealZoneText();
    local msg = "Nothing";
    local potFound, potBag, potSlot, duration;

    --based on battleground zone use 'Major Mana Draught'
    potFound, potBag, potSlot = isInBag(potion[1]);
    if (potFound == true and (zone == "Warsong Gulch" or zone == "Alterac Valley" or zone == "Arathi Basin")) then
        _, duration, _ = GetContainerItemCooldown(potBag, potSlot);
        if (duration == 0) then
            UseContainerItem(potBag, potSlot, 1);
            msg = potion[1];
        else
            msg = potion[1] .. ", but it is on Cooldown";
        end

        --otherwise loop through the rest of the possible potions and use the highest value potion available
    else
        for i = 2, _getn(potion), 1 do
            potFound, potBag, potSlot = isInBag(potion[i]);
            if (potFound) then
                _, duration, _ = GetContainerItemCooldown(potBag, potSlot);
                if (duration == 0) then
                    UseContainerItem(potBag, potSlot, 1);
                    msg = potion[i];
                else
                    msg = potion[i] .. ", but it is on Cooldown";
                end
                break;
            end
        end
    end

    DEFAULT_CHAT_FRAME:AddMessage("CWF: Attempting to use " .. msg .. "!");
end

--One action to use an exotic Mana booster based on item availability
function UseExoticManaBooster()
    local potion = { 'Nordanaar Herbal Tea', 'Dark Rune', 'Demonic Rune' }

    local msg = "Nothing"
    local potFound, potBag, potSlot, duration
    for i = 1, _getn(potion), 1 do
        potFound, potBag, potSlot = isInBag(potion[i])
        if (potFound) then
            _, duration, _ = GetContainerItemCooldown(potBag, potSlot)
            if (duration == 0) then
                UseContainerItem(potBag, potSlot, 1)
                msg = potion[i]
            else
                msg = potion[i] .. ", but it is on Cooldown"
            end
            break
        end
    end

    DEFAULT_CHAT_FRAME:AddMessage("CWF: Attempting to use " .. msg .. "!")
end

--One action to use an armor potion based on item availability
function UseArmorPotion()
    local potion = { 'Greater Stoneshield Potion', 'Lesser Stoneshield Potion' }

    local msg = "Nothing"
    local potFound, potBag, potSlot, duration
    for i = 1, _getn(potion), 1 do
        potFound, potBag, potSlot = isInBag(potion[i])
        if (potFound) then
            _, duration, _ = GetContainerItemCooldown(potBag, potSlot)
            if (duration == 0) then
                UseContainerItem(potBag, potSlot, 1)
                msg = potion[i]
            else
                msg = potion[i] .. ", but it is on Cooldown"
            end
            break
        end
    end

    DEFAULT_CHAT_FRAME:AddMessage("CWF: Attempting to use " .. msg .. "!")
end

--One action to use a Health potion based on location and item availability
function UseHealthPotion()
    local potion = { 'Major Healing Draught', 'Major Healing Potion', 'Combat Healing Potion', 'Superior Healing Potion', 'Greater Healing Potion', 'Healing Potion', 'Lesser Healing Potion', 'Minor Healing Potion' };
    local zone = GetRealZoneText();
    local msg = "Nothing";
    local potFound, potBag, potSlot, duration;

    --based on battleground zone use 'Major Healing Draught'
    potFound, potBag, potSlot = isInBag(potion[1]);
    if (potFound == true and (zone == "Warsong Gulch" or zone == "Alterac Valley" or zone == "Arathi Basin")) then
        _, duration, _ = GetContainerItemCooldown(potBag, potSlot);
        if (duration == 0) then
            UseContainerItem(potBag, potSlot, 1);
            msg = potion[1];
        else
            msg = potion[1] .. ", but it is on Cooldown";
        end

        --otherwise loop through the rest of the possible potions and use the highest value potion available
    else
        for i = 2, _getn(potion), 1 do
            potFound, potBag, potSlot = isInBag(potion[i]);
            if (potFound) then
                _, duration, _ = GetContainerItemCooldown(potBag, potSlot);
                if (duration == 0) then
                    UseContainerItem(potBag, potSlot, 1);
                    msg = potion[i];
                else
                    msg = potion[i] .. ", but it is on Cooldown";
                end
                break;
            end
        end
    end

    DEFAULT_CHAT_FRAME:AddMessage("CWF: Attempting to use " .. msg .. "!");
end

--Uses available Mana Gem
function UseManaGem()
    local msg = "Nothing";
    local gem = { "Mana Ruby", "Mana Citrine", "Mana Jade", "Mana Agate" };
    local hasGem, gemBag, gemSlot;
    for i = 1, 4 do
        hasGem, gemBag, gemSlot = isInBag(gem[i]);
        if (hasGem == true) then
            UseContainerItem(gemBag, gemSlot, 1);
            msg = gem[i];
            break;
        end
    end
    DEFAULT_CHAT_FRAME:AddMessage("CWF: Attempting to use " .. msg .. "!");
end

--Uses available Healthstone
function UseHealthstone()
    local msg = "Nothing";
    local healthstone = { "Major Healthstone", "Greater Healthstone", "Healthstone", "Lesser Healthstone", "Minor Healthstone" };
    local hasStone, stoneBag, stoneSlot;
    for i = 1, 5 do
        hasStone, stoneBag, stoneSlot = isInBag(healthstone[i]);
        if (hasStone == true) then
            UseContainerItem(stoneBag, stoneSlot, 1);
            msg = healthstone[i];
            break;
        end
    end
    DEFAULT_CHAT_FRAME:AddMessage("CWF: Attempting to use " .. msg .. "!");
end

--Decide which spell to cast based on Clearcast proc
function MageDPM(spell1, spell2)
    local clearcast = isBuffNameActive("Clearcasting");

    if (clearcast) then
        SpellStopCasting();
        CastSpellByName(spell1);
    else
        CastSpellByName(spell2);
    end

end

--Equip Fishing pole or begin fishing if a pole is equipped, holding down any modifier (ctrl, alt, shift) will attach the best available lure
function Fish(pole)
    local mainHandLink = GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot"));
    local mainHandName = getItemName(mainHandLink);
    local pole_hasPole, pole_bag, pole_slot = isInBag(pole);
    local mod = false;
    local lures = { "Aquadynamic Fish Attractor", "Flesh Eating Worm", "Bright Baubles", "Nightcrawlers", "Shiny Bauble" };
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
                break;
            end
        end
    elseif (mainHandName ~= nil and mainHandName == pole) then
        CastSpellByName("Fishing");
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

--Druid macro for shifting into bear form and using Feral Charge
function FeralCharge()
    local currentForm = getShapeshiftForm();

    if (currentForm == 1) then
        CastSpellByName("Feral Charge");
    else
        if (getSpellId("Dire Bear Form") ~= nil) then
            Shapeshift("Dire Bear Form", false, true);
        else
            Shapeshift("Bear Form", false, true);
        end
    end
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
    for i = 32, 0, -1 do --00 exhaustive search from 32 (most recent buff) down to 1 (oldest buff)

        -- print("*****")

        buffIndex = GetPlayerBuff(i)
        if buffIndex ~= nil and buffIndex >= 0 then -- better not to break out of the loop if we get an intermittent negative or nil
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
                        break;
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
--            for _, buffInfo in pairs(matchedBuffs) do
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
--            for _, buffInfo in pairs(matchedBuffs) do
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
    for i = 32, 0, -1 do --00 exhaustive search from 32 (most recent buff) down to 1 (oldest buff)

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
                        or ( buff15 ~= nil and ((exactMatchingNotRegex and currentBuffName == buff15) or (not exactMatchingNotRegex and _strfind(currentBuffName, buff15))) ); --@formatter:on

                if currentBuffIsMatching then
                    -- print("** [" .. time() .. "] Matching buff found: currentBuffName=" .. _tostring(currentBuffName) .. " at index i=" .. _tostring(i))

                    matchedBuffs = matchedBuffs or {}; -- lazy allocation
                    _tblinsert(matchedBuffs, {
                        Index = i - 1, --  todo  in vanilla-wow we should return 'i-1' but from tbc-wow onwards we should return just 'i' because the APIs for CancelBuff() and so on changed in tbc!
                        BuffName = currentBuffName,
                    });

                    matchedBuffsCount = matchedBuffsCount + 1;

                    if stopAtFirstMatch then
                        break;
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
--            for _, buffInfo in pairs(matchedBuffs) do
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
--            for _, buffInfo in pairs(matchedBuffs) do
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

    if useNamesNotTextures then -- buff-name-based filtering
        if useExactMatchingNotRegexes then -- dont turn this into ternary as it will break if the first find returns nil!
            matchingBuffIndex = findMostRecentActiveBuff("player", buffString1, buffString2, buffString3, buffString4, buffString5, buffString6, buffString7, buffString8, buffString9, buffString10, buffString11, buffString12, buffString13, buffString14, buffString15)
        else
            matchingBuffIndex = findMostRecentRegexedActiveBuff("player", buffString1, buffString2, buffString3, buffString4, buffString5, buffString6, buffString7, buffString8, buffString9, buffString10, buffString11, buffString12, buffString13, buffString14, buffString15)
        end
    else -- buff-texture-based filtering
        if useExactMatchingNotRegexes then -- dont turn this into ternary as it will break if the first find returns nil!
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

local _havePrintedDeprecationWarningFor_isBuffNameActive = false;

--[DEPRECATED: Use findRegexedActiveBuffs() instead] Reads unit's buffs and returns isBuffActive, buffIndex, numBuffs
function isBuffNameActive(buff, unit)
    if not _havePrintedDeprecationWarningFor_isBuffNameActive then
        DEFAULT_CHAT_FRAME:AddMessage("CWF: [DEPRECATION WARNING] isBuffNameActive() is deprecated, please use findRegexedActiveBuffs() instead!", 1, 0.5, 0);
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
function MountAQ(normal, aq)
    local normalFound, normalBag, normalSlot = isInBag(normal);
    local aqFound, aqBag, aqSlot = isInBag(aq);
    local zone = GetRealZoneText();

    if ((zone == "Temple of Ahn'Qiraj" or zone == "Ahn'Qiraj") and aqFound == true) then
        UseContainerItem(aqBag, aqSlot, 1);
    elseif (normalFound) then
        UseContainerItem(normalBag, normalSlot, 1);
    end
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

--returns id of a spell from player's spellbook
function getSpellId(spell)
    local i = 1
    while true do
        local spellName, _ = GetSpellName(i, BOOKTYPE_SPELL)
        if not spellName then
            do
                break
            end
        end
        if spellName == spell then
            return i;
        end
        i = i + 1
    end
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

local bracketEnd = "]";
local bracketStart = "|h";

--Helper function to get an item name given an item link
function getItemName(itemLink)
    if itemLink == nil then
        return nil
    end

    return _strsub(
            itemLink,
            _strfind(itemLink, bracketStart, 1, true) + 3,
            _strfind(itemLink, bracketEnd, 1, true) - 1
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

    for buffId=0, 32, 1 do -- in twow we need to also scan buffId=0 despite what the docs say about buffId being 1..16
        buffIndex = g(buffId);
        if buffIndex ~= nil and buffIndex >= 0 then -- prefer exhaustive scanning
            local buffName = _strsplit(GetPlayerBuffTexture(buffIndex) or "", "Icons\\");
            DEFAULT_CHAT_FRAME:AddMessage("buffId=" .. _tostring(buffId) .. " (buffIndex=" .. _tostring(buffIndex) .. "): " .. _tostring(buffName[2] or "nil"));
        end
    end
end
