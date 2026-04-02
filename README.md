# CerniesWonderfulFunctions

Authors: Cernie (original), dsidirop (enhancements \& maintenance from 2024 onwards)

Donations: Visit [Cernie's original project](https://github.com/Cernie/CerniesWonderfulFunctions) if you want to make a donation his way.


# Installation

Unzip the CerniesWonderfulFunctions folder into WoW directory Interface/Addons folder. Remove the -master from the folder name.


# Introduction


CerniesWonderfulFunctions is a collection of script functions for Vanilla World of Warcraft (1.12.1) designed for easy use of PvP Battleground items such as bandages, healing/mana potions, and food/drink. In addition, common useful macro functions are available as well. 
These functions are flexible in what types of items the player wishes to use, meaning players of all levels can take full advantage of them. Using the methods is as simple as creating a new macro and writing a single line for /script <functionName>(<parameters>). Directions and examples are found below.

# List of Functions
- UseBGBandage(wg, ab, av, normal)
One action for using Battleground specific bandages, or use normal bandages if not in a Battleground. The parameters
are based on the item names for each battleground the player wishes to use. If the player is not in a battleground, 
the function will then use their "normal" bandage.
For example, the following command (the quotation marks are required):

<code>/script UseBGBandage('Warsong Gulch Runecloth Bandage', 'Arathi Basin Runecloth Bandage', 'Alterac Heavy Runecloth Bandage', 'Heavy Runecloth Bandage')</code>

- UseBGBiscuit(wg, ab, av)
One action for using Battleground specific biscuits (or food or water if the player doesn't want to use the biscuits) instead of 
regular food/water. The parameters are based on the item names for each battleground the player wishes to use.
For example, the following command (the quotation marks are required):

<code>/script UseBGBiscuit('Warsong Gulch Enriched Ration', 'Arathi Basin Enriched Ration', 'Alterac Manna Biscuit');</code>

- UseBestBandage()

One action to use the best bandage the player has in their bags. This is essentially a convenience alias to UseBGBandage().

For example, the following macro command:

<code>/script UseBestBandage()</code>

- UseManaPotion()
One action to use a Mana potion based on location and item availability. This prioritizes using Battleground specific
mana potions first, then the PvP 'Combat Mana Potion' and then finally if neither are available, uses the best mana potion
the player does have in their bags. This is designed to use the PvP specific potions and save the player from using the 
most expensive potions all the time when they might want to save them for PvE raids or other times.
Order of precedence:
* Major Mana Draught
* Major Mana Potion
* Combat Mana Potion
* Superior Mana Potion
* Greater Mana Potion
* Mana Potion
* Lesser Mana Potion
For example, the following macro command:

<code>/script UseManaPotion()</code>

- UseExoticManaBooster()

One action to use a Mana tea/runes based on item availability. Order of precedence:

* Nordanaar Herbal Tea (turtle wow item)
* Dark Rune
* Demonic Rune

For example, the following macro command:

<code>/script UseExoticManaBooster()</code>

- UseHealthPotion()
One action to use a Healing potion based on location and item availability. This prioritizes using Battleground specific
healing potions first, then the PvP 'Combat Healing Potion' and then finally if neither are available, uses the best 
healing potion the player does have in their bags. This is designed to use the PvP specific potions and save the player 
from using the most expensive potions all the time when they might want to save them for PvE raids or other times.
Order of precedence:
* Major Healing Draught
* Major Healing Potion
* Combat Healing Potion
* Superior Healing Potion
* Greater Healing Potion
* Healing Potion
* Lesser Healing Potion
For example, the following macro command:

<code>/script UseHealthPotion()</code>

- UseManaGem()
Uses available Mana Gem.
For example, the following macro command:

<code>/script UseManaGem()</code>

- UseArmorPotion()
Uses any available Armor (Stoneshield etc) Potion.

For example, the following macro command:

<code>/script UseArmorPotion()()</code>

- UseHealthstone()
Uses available Healthstone.
For example, the following macro command;

<code>/script UseHealthstone()</code>

- Nom(water, food)
One action for drinking and eating, press twice to do both. This function works in and out of PvP Battlegrounds as it uses 
the player's normal food and drink not specific to a Battleground. It only begins drinking or eating if the player is 
currently not already drinking or eating and not already at full health or mana, saving them from wasted drink and food. 
The water and food parameters are the names of the items the player wants to use.
For example, the following macro command:

<code>/script Nom('Conjured Sparkling Water', 'Conjured Sweet Roll')</code>

- NomFood(food)
The non-mana using class version of the above Nom function.
For example, the following macro command:

<code>/script NomFood('Conjured Sweet Roll')</code>

- NomWater(water)
The water only version of the above Nom function.
For example, the following macro command:

<code>/script NomFood('Conjured Sparkling Water')</code>

- MageDPM(spell1, spell2)
Useful for Mage, Shaman or Druid with a clearcasting talent. Casts spell2 until a clearcast proc occurs then stops casting and
casts spell1. A mage for instance, could switch between rank 1 and max rank Arcane Missiles for getting the most damage once OOM.
For example, the following macro command:

<code>/script MageDPM("Arcane Missiles", "Arcane Missiles(Rank 1)");</code>

- hasClearcastProc()
Helper used by `MageDPM()` to detect whether a Clearcasting-style proc is currently active. Returns boolean (`true`/`false`).

```lua
if hasClearcastProc() then
    CastSpellByName("Arcane Missiles")
end
```

- ToggleEquipItemSlot(slot, item1, item2)
Switches between two pieces of gear for a specified item slot. The slot parameter requires the name of the Inventory slot constant.
For example, the following macro command:

<code>/script ToggleEquipItemSlot("SECONDARYHANDSLOT", "Talon of Furious Concentration", "Skull of Impending Doom");</code>

Note that the item names are treated as case-sensitive **regexes** so you can use partial names if desired as long as your regex matches the desired
item from its first character. This means that if the name of your desired item contains special regex characters (like . * + ? etc) you will need to escape them!

In order to avoid mismatches with similar named items, it's recommended to enforce exact string-matching like so:

```lua
ToggleEquipItemSlot("SECONDARYHANDSLOT", "^Talon of Furious Concentration$", "^Skull of Impending Doom$")
```

This will ensure that only the exact item "Talon of Furious Concentration" is matched (and not something like "Talon of Furious Concentration of the Eagle")

Examples:

    - "Time[-]Shifting Wheel" would match "Time-Shifting Wheel" but if you use "Time-Shifting Wheel" without escaping the '-' then it would not match!
    - "Talon" would work in place of "Talon of Furious Concentration" (but not "talon" or "alon")
    - "Skull.*Doom" would work in place of "Skull of Impending Doom" (assuming of course that no other item matches this regex)
    - ".*Doom" would work in place of "Skull of Impending Doom" (assuming of course that no other item matches this regex)

- Shapeshift(form, isPowerShift, isGCD)
Druid function to use a specific shapeshift based on the name (ie "Cat Form"). Set isPowerShift to true if you want to shift out and back in, or
false if you do not. Set isGCD to true if you want to wait to shift until you are off the global cooldown, or false if you do not.
For example, the following macro command:

<code>/script Shapeshift("Travel Form", true, true);</code>

- CancelShapeshift()
Druid function to shift the player out of form into humanoid form. Useful in macros for when the player wants to cast a spell. Requires two 
button presses when used in this manner.
For example, the following macro command:

<code>/script CancelShapeshift();
        
/script CastSpellByName("Regrowth");</code>

- FeralCharge()
Druid function to shift the player into Bear Form and cast Feral Charge. Multiple button presses are required as the function will also shift the 
player out of other forms and then into Bear Form.
For example, the following macro command:

<code>/script FeralCharge();</code>

- getShapeshiftForm()
Druid function that returns the index of the current form the player is in. Returns 0 if the player is in humanoid form. Useful helper function for 
custom macros.
For example, the following macro command:

<code>/script if(getShapeshiftForm() == 1) then DEFAULT_CHAT_FRAME:AddMessage("I am in Bear Form"); end;</code>

- findRegexedActiveBuffs(unit, buffRegex1, buffRegex2, buffRegex3, ...)

Scans the unit's buffs and returns (matchesArray, matchedBuffsCount) where matchesArray is an array of elements { Index = (number), BuffName = (string) }
sorted by descending buff-index (ie: highest buff-index first) or nil if no buffs matched

Note that the regexes are applied in a case-sensitive manner (this behaviour is different from the legacy isBuffNameActive() which was case-insensitive)

Example usage:

```lua
local matchedBuffs = findRegexedActiveBuffs("player", "^Blessing of .*", "^Divine .*")
if matchedBuffs ~= nil then
    for _, buffInfo in pairs(matchedBuffs) do
        print("** index=" .. buffInfo.Index .. ", name='" .. buffInfo.BuffName .. "'")
    end
end
```

- findActiveBuffs(unit, buff1, buff2, buff3, ...)

Like findRegexedActiveBuffs() but does exact string matching instead of regex matching.

```lua
local matchedBuffs = findActiveBuffs("player", "Blessing of Protection", "Divine Shield")
if matchedBuffs ~= nil then
    for _, buffInfo in pairs(matchedBuffs) do
        print("** index=" .. buffInfo.Index .. ", name='" .. buffInfo.BuffName .. "'")
    end
end
```

- findMostRecentActiveBuff(unit, buff1, buff2, buff3, ...)

Like findActiveBuffs() but returns only the most recently applied buff (ie: the one with the highest buff-index) or nil if none of the specified buffs are active.

```lua
local matchingBuffIndex, matchingBuffName = findMostRecentActiveBuff("player", "Blessing of Protection", "Divine Shield")
if matchingBuffIndex ~= nil then
    print("Most recent buff is index=" .. matchingBuffIndex .. ", name='" .. matchingBuffName .. "'")
end
```

- findMostRecentRegexedActiveBuff(unit, buff1, buff2, buff3, ...)

Like findMostRecentActiveBuff() but uses regex matching instead of exact string matching.

```lua
local matchingBuffIndex, matchingBuffName = findMostRecentRegexedActiveBuff("player", "^Blessing of .*", "^Divine .*")
if matchingBuffIndex ~= nil then
    print("Most recent buff is index=" .. matchingBuffIndex .. ", name='" .. matchingBuffName .. "'")
end
```

- findActiveBuffsViaTextures(unit, exactBuffTexture1, exactBuffTexture2, exactBuffTexture3, ...)
Scans buff **texture paths** (not localized names) and returns `(matchesArray, matchedBuffsCount)`. Matching is exact and case-insensitive.

```lua
local matches = findActiveBuffsViaTextures("player", "interface\\icons\\spell_holy_devotionaura")
if matches ~= nil then
    print("Found matching texture buffs")
end
```

- findActiveBuffsViaRegexedTextures(unit, buffTextureRegex1, buffTextureRegex2, buffTextureRegex3, ...)
Like `findActiveBuffsViaTextures()` but texture matching is regex-based and case-sensitive.

```lua
local matches = findActiveBuffsViaRegexedTextures("player", ".*Spell_Holy_SealOfWisdom$")
```

- findMostRecentActiveBuffViaTextures(unit, exactBuff1, exactBuff2, exactBuff3, ...)
Returns `(matchingBuffIndex, matchingBuffTexture)` for the most recently applied matching buff texture, or `nil` if none matched.

```lua
local idx, texture = findMostRecentActiveBuffViaTextures("player", "interface\\icons\\spell_holy_devotionaura")
```

- findMostRecentActiveBuffViaRegexedTextures(unit, buffRegex1, buffRegex2, buffRegex3, ...)
Like `findMostRecentActiveBuffViaTextures()` but uses case-sensitive regex matching against texture paths.

```lua
local idx, texture = findMostRecentActiveBuffViaRegexedTextures("player", ".*Spell_Holy_SealOf.*$")
```

- CancelPlayerBuffByName(throttlingTimeInSeconds, exactBuff1, exactBuff2, exactBuff3, ...)

Note: You're probably better off using CancelPlayerBuffViaTextures() considering that it has proven more reliable in practice.

Cancels the first matching buff found on the player from the list of specified exact buff names. Note that this function is throttled
to only allow one buff cancellation every 'throttlingTimeInSeconds' seconds. This is in order to prevent certain nasty bugs that
can crop up when mass-cancelling buffs (like losing all buffs). There is no way around limitation. Default value for throttlingTimeInSeconds
is 1 second if you pass nil or negative time.

<code>/script CancelPlayerBuffByName(-1, "Blessing of Protection", "Divine Shield", "Divine Protection")</code>

- CancelPlayerBuffByRegexedName(throttlingTimeInSeconds, regexedBuff1, regexedBuff2, regexedBuff3, ...)

Note: You're probably better off using CancelPlayerBuffViaRegexedTextures() considering that it has proven more reliable in practice.

Like CancelPlayerBuffByName() but uses regex matching instead of exact string matching.

<code>/script CancelPlayerBuffByRegexedName(-1, "^Blessing of .*", "^Divine .*")</code>

- CancelPlayerBuffViaTextures(throttlingTimeInSeconds, texture1, texture2, texture3, ...)

Cancels the first matching buff found on the player from the list of the specified buff-texture-names. Note that this function is
intentionally being subjected to throttling to only allow one buff cancellation every 'throttlingTimeInSeconds' seconds. This is in order to prevent
certain nasty bugs that can crop up when mass-cancelling buffs (like losing all buffs). There is no way around limitation. Default value for throttlingTimeInSeconds
is 1 second if you pass nil or negative time. You have to provide the full path to the texture i.e. "Interface\\Icons\\Spell_Holy_SealOfProtection".
The string matching is exact but case-insensitive. Returns true if any matching buff was found, false otherwise.

```lua
local found = CancelPlayerBuffViaTextures(-1, "interface\\icons\\spell_holy_sealofprotection", "interface\\icons\\spell_holy_divineintervention", "interface\\icons\\spell_holy_divineprotection")
if found then
    -- taunt the boss back onto you
end
```

- CancelPlayerBuffViaRegexedTextures(throttlingTimeInSeconds, regexedTexture1, regexedTexture2, regexedTexture3, ...)

Like CancelPlayerBuffViaTextures() but uses regex case-sensitive-matching instead of exact string matching.

```lua
local found = CancelPlayerBuffViaRegexedTextures(-1, "[Ss]pell_[Hh]oly_[Rr]estoration$", "[Ss]pell_[Hh]oly_[Dd]ivine[Ii]ntervention$", "[Ss]pell_[Hh]oly_[Ss]eal[Oo]f[Pp]rotection$")
if found then
    -- taunt the boss back onto you
end
```

- CancelPaladinImmunities(throttlingTimeInSeconds)

Cancels any paladin divine shield, divine intervention, divine protection or blessing/hand of protection buffs. Essentially, this is a
handy out-of-the-box shortcut to CancelPlayerBuffViaTextures(). Note that this function is throttled to only allow one buff cancellation every
'throttlingTimeInSeconds' seconds. This is in order to prevent certain nasty bugs that can crop up when mass-cancelling buffs (like losing all buffs).
There is no way around limitation. Default value for throttlingTimeInSeconds is 1 second if you pass nil or negative time.

```lua
local foundAndCancelled = CancelPaladinImmunities()
if foundAndCancelled then
    -- taunt the boss back onto you
end
```

- CancelPaladinRighteousFury(throttlingTimeInSeconds)

Cancels any paladin righteous fury buff. Essentially, this is a handy out-of-the-box shortcut to CancelPlayerBuffViaTextures(). Note that this function is throttled
to only allow one buff cancellation every 'throttlingTimeInSeconds' seconds. This is in order to prevent certain nasty bugs that can crop up when mass-cancelling buffs
(like losing all buffs). There is no way around limitation. Default value for throttlingTimeInSeconds is 1 second if you pass nil or negative time.

```lua
local foundAndCancelled = CancelPaladinRighteousFury()
if foundAndCancelled then
    -- do something now that righteous fury is off
end
```

- IsPaladinRighteousFuryActive()
Returns `true` if the paladin has righteous fury buff active, otherwise returns `false`.

```lua
if IsPaladinRighteousFuryActive() then
    -- do something if righteous fury is on
else
    -- do something else if righteous fury is off
end
```

- EnsurePaladinRighteousFuryIsOn()

Ensures that the paladin has righteous fury buff active. If not, it will cast righteous fury. Returns true if Righteous Fury got turned on just now,
false if it was already on.

```lua
local turnedOnNow = EnsurePaladinRighteousFuryIsOn()
if turnedOnNow then
    -- do something now that righteous fury just got turned on
end
```

- CancelPriestShadowform()
Cancels priest Shadowform if active. Returns `true` if Shadowform was found and canceled, otherwise `false`.

```lua
local cancelled = CancelPriestShadowform()
```

- EnsurePriestShadowformIsOn()
Ensures priest Shadowform is active; if not active, casts it. Returns `true` when the spell exists and is (or becomes) active, `false` when unavailable.

```lua
local ok = EnsurePriestShadowformIsOn()
```

- isEdwardTheOddBuffProcced()

Function to determine if the buff from 'Hand of Edward the Odd' (world BoE weapon) is currently active. Returns boolean (true or false).

```lua
local isActive = isEdwardTheOddBuffProcced()
if isActive then
    CastSpellByName("Holy Light", 1) -- or CastSpellByName("Holy Wrath")
end
```

- isBuffNameActive(buff, unit)
Deprecated helper (prefer `findRegexedActiveBuffs()`). Checks whether the named buff is active and returns `isBuffActive`, `buffIndex`, `numBuffs`.

<code>/script local isActive, index, numBuffs = isBuffNameActive("Arcane Intellect", "player")</code>

- isDebuffNameActive(debuff, unit)
Function similar to isBuffNameActive(buff, unit) but for debuffs. However, this DOES apply to enemy targets.
For example, the following macro command:

<code>/script local isDebuff, index, numDebuffs = isDebuffNameActive("Corruption", "target") if(isDebuff == false) then CastSpellByName("Corruption"); end;</code>

- findAttackActionSlot()
Function to find an Attack Action on the players action bars. Returns the index of the action bar slot if the action is an attack action and if it 
is currently being used (blinking), otherwise returns 0 if no action is found. Useful in custom macros for determining if the player is currently 
auto attacking.
For example, the following macro command:

<code>/script if(findAttackActionSlot() == 0) then AttackTarget(); end;</code>

- findAutoRangedActionSlot()
Function similar to findAttackActionSlot() but for ranged or wand auto attacks.
For example, the following macro command:

<code>/script if(findAutoRangedActionSlot() == 0) then CastSpellByName("Shoot"); end;</code>

- isTargetDebuff(target, debuff)
Function to determine if a debuff texture name is active on the target (ie "player" or "target"). Returns boolean (true or false) if found. Useful to 
check a texture name if the debuff name is unknown, otherwise refer to isDebuffNameActive(debuff, unit).
For example, the following macro command:

<code>/script if(isTargetDebuff("target", "Ability_GhoulFrenzy")) then CastSpellByName("Ferocious Bite") else CastSpellByName("Rip") end;</code>

- ModifySpellAction(options)
This function achieves something similar as patch 2.0 (and beyond) [mod: <modifier>] syntax in macros. I have two versions, one more advanced than the other. 
The usual rules apply, so if you add this macro to your 1 button but have shift + 1 bound to another button, holding shift + 1 will use that action rather than 
the one in this macro. Clicking does bypass this for ctrl and alt modifiers, however.
For example, the following macro command:

<code>/script ModifySpellAction{unmod="Conjure Water(Rank 7)", shift="Conjure Food(Rank 6)", ctrl="Conjure Mana Ruby", alt="Conjure Mana Citrine"};</code>

- ModifyKeyAction(options)
Function similar to ModifySpellAction(options), but can do more than just cast spells or use abilities.
For example, the following macro command (requires SuperMacro addon):

<code>/script ModifyKeyAction{unmod = 'CastSpellByName("Fire Blast")', shift = 'CastSpellByName("Fire Blast(Rank 1)")', alt = 'use("Iron Grenade")', ctrl = 'Macro("MountBoots")'};</code>

- MountAQ(normal, aq)
Function to use a mount based on location. If the player is in AQ40 the function will use the specified AQ40 mount, otherwise the function will use the 
player's normal mount.
For example, the following macro command:

<code>/script MountAQ("Swift White Ram", "Green Qiraji Resonating Crystal");</code>

- UseItemInBag(itemName, self)
Function to use an item in the player's container bags based on the name of the item. The parameter "self" is optional, pass 1 to use the item on yourself.
For example, the following macro command:

<code>/script UseItemInBag("Iron Grenade");</code>
<code>/script UseItemInBag("Ez[-]Thro Dynamite");</code>

You may also chain multiple items together like so - the first item found will be used:

```lua
local success = UseItemInBag(" Grenade$") or UseItemInBag(" Dynamite$") or UseItemInBag(" Bomb$")
```

Better yet, if you have supermacro you can write a dedicated function that is more readable:

<code>/script MyBombGrabber();</code>

```lua
-- and now in the supermacro script section define your function
function MyBombGrabber()
   _ = false -- comment / uncomment lines as intended
          or  UseItemInBag(".* Dynamite$")  -- least potent
          or  UseItemInBag(".* Grenade$")
          or  UseItemInBag(".* Bomb$") -- most potent
end
```

Note that the item names are treated as case-sensitive **regexes** so you can use partial names if desired as long as your regex matches the desired
item from its first character. This means that if the name of your desired item contains special regex characters (like . * + ? etc) you will need to escape them!

Examples:

    - "Time[-]Shifting Wheel" would match "Time-Shifting Wheel" but if you use "Time-Shifting Wheel" without escaping the '-' then it would not match!
    - "Talon" would work in place of "Talon of Furious Concentration" (but not "talon" or "alon")
    - "Skull.*Doom" would work in place of "Skull of Impending Doom" (assuming of course that no other item matches this regex)
    - ".*Doom" would work in place of "Skull of Impending Doom" (assuming of course that no other item matches this regex)

- getSpellId(spell)
Function to find the spell id given a spell name, returns the spell id necessary for other API calls. Useful to reduce macro length when getting information
about a spell from the player's spell book.
For example, the following macro command:

<code>/script local _, duration, _ = GetSpellCooldown(getSpellId("Swiftmend"), BOOKTYPE_SPELL) if(duration == 0) then CastSpellByName("Swiftmend") else DEFAULT_CHAT_FRAME:AddMessage("Swiftmend on cooldown.") end;</code>

- printAllSpellsOfCurrentPlayer()
Debug helper that prints all current spellbook entries grouped by localized spell name and rank/texture info.

```lua
printAllSpellsOfCurrentPlayer()
```

- haveSpell(localizedSpellBaseName, optionalRank)
Returns `true` if the player has the specified localized spell name in the spellbook. If `optionalRank` is provided, checks that rank specifically.

```lua
local hasRank1 = haveSpell("Frostbolt", 1)
```

- tryGetLocalizedSpellNameByExactTextureFilePath(fullTextureFilePath)
Finds a localized spell name by exact (case-insensitive) texture path match in the player spellbook. Returns localized spell name or `nil`.

```lua
local name = tryGetLocalizedSpellNameByExactTextureFilePath("Interface\\Icons\\Spell_Shadow_Shadowform")
```

- tryGetLocalizedSpellNameByRegexedTextureFilePath(regexedFullTextureFilePath)
Like `tryGetLocalizedSpellNameByExactTextureFilePath()` but uses regex matching against spell texture paths.

```lua
local name = tryGetLocalizedSpellNameByRegexedTextureFilePath("[Ss]pell_[Ss]hadow_[Ss]hadowform$")
```

- isSpellOnCd(spell)
Function to find out if a spell is on Cooldown based on the spell name. Returns true or false.
For example, the following macro command:

<code>/script local cd = isSpellOnCd("Swiftmend") if(not cd) then CastSpellByName("Swiftmend") else DEFAULT_CHAT_FRAME:AddMessage("Swiftmend on cooldown!") end;</code>

- isContainerItemOnCd(itemName)
Function to find out if a container item is on Cooldown based on the item name. Returns true or false.
For example, the following macro command:

<code>/script local cd = isContainerItemOnCd("Major Healing Potion") if(not cd) then UseContainerItem("Major Healing Potion") end;</code>

- findActionSlot(spellTexture)
Function to find an action slot id based on the texture of the button. Returns the id of the action slot or 0 if not found.
Useful in cases where getSpellId(spell) is not available.
For example, the following macro command:

<code>/script if(IsUsableAction(findActionSlot("Ability_Warrior_Revenge")) == 1) then CastSpellByName("Revenge") else CastSpellByName("Heroic Strike") end</code>

- ToggleAutoAttack(switch)
Function to turn auto attack on or off based on what is passed to switch. Switch can be either "on" or "off".
For example, the following macro command:

<code>/script ToggleAutoAttack("on")</code>

- CastSpellIfSpecifiedBuffsAreAllMissing(scanUnit, spell, onSelf, useStopCastingFirst, buff1, buff2, buff3, ...)

Casts the specified spell if the specified regexed-buffs are all missing from the 'scanUnit'. If the parameter onself is set to false then the
spell will be cast on the player's target instead of on the player. If the parameter useStopCastingFirst is set to true then
the function will first stop any current spellcasting before attempting to cast the specified spell.

Returns true if the spell was cast (because all specified buffs where missing), false otherwise.

<code/>/script CastSpellIfSpecifiedBuffsAreAllMissing("player", "Righteous Fury")</code>
<code/>/script CastSpellIfSpecifiedBuffsAreAllMissing("player", "Fire Resistance Aura")</code>
<code/>/script CastSpellIfSpecifiedBuffsAreAllMissing("player", "Fire Resistance Aura", true, true, "Fire Resistance Aura", "Frost Resistance Aura", "Shadow Resistance Aura")</code>

You can even chain such calls like so:

```lua
-- aura dancing for paladins
_ =      CastSpellIfSpecifiedBuffsAreAllMissing("player",   "Devotion Aura") -- will swap back and forth between these two
     or  CastSpellIfSpecifiedBuffsAreAllMissing("player",   "Fire Resistance Aura")
```

- CastSpellIfSpecifiedRegexedBuffsAreAllMissing(scanUnit, spell, onSelf, useStopCastingFirst, regexBuff1, regexBuff2, regexBuff3, ...)

Like CastSpellIfSpecifiedBuffsAreAllMissing() but uses regex-matching instead of exact string matching.

- CastSpellIfAnySpecifiedBuffIsPresent(scanUnit, spell, onSelf, useStopCastingFirst, buff1, buff2, buff3, buff4, buff5, buff6, buff7, buff8, buff9, buff10, buff11, buff12, buff13, buff14, buff15)

This is the inverse of CastSpellIfSpecifiedBuffsAreAllMissing(). This function casts the specified spell if any of the specified buffs are present on the 'scanUnit'.

- CastSpellIfAnySpecifiedRegexedBuffIsPresent(scanUnit, spell, onSelf, useStopCastingFirst, buffRegex1, buffRegex2, buffRegex3, buffRegex4, buffRegex5, buffRegex6, buffRegex7, buffRegex8, buffRegex9, buffRegex10, buffRegex11, buffRegex12, buffRegex13, buffRegex14, buffRegex15)

Like CastSpellIfAnySpecifiedBuffIsPresent() but uses regex-matching instead of exact string matching.

- isInBag(itemName)
Function to find a container item based on the item name. Returns boolean (true/false) based on if the item is found, the item's bag id, and the item's slot id.
Useful in greatly reducing macro length and helps in logic to determine if an item gets used or equipped.
For example, the following macro command:

<code>/script local found, bag, slot = isInBag("Major Healing Potion") if(found) then UseContainerItem(bag, slot, 1) else DEFAULT_CHAT_FRAME:AddMessage("Major Healing Potion not found!") end;</code>

Note that the item names are treated as case-sensitive **regexes** so you can use partial names if desired as long as your regex matches the desired
item from its very first character. This means that if the name of your desired item contains special regex characters (like . * + ? etc) you will need to escape them!

In order to avoid mismatches with similar named items, it's recommended to enforce exact string-matching like so:

```lua
local found, bag, slot = isInBag("^Major Healing Potion$")
if (found) then
    UseContainerItem(bag, slot, 1)
else
    DEFAULT_CHAT_FRAME:AddMessage("Major Healing Potion not found!")
end
```

This will ensure that only the exact item "Major Healing Potion" is matched and not something like "Major Healing Potion of Foobar".

Examples:

    - "Time[-]Shifting Wheel" would match "Time-Shifting Wheel" but if you use "Time-Shifting Wheel" without escaping the '-' then it would not match!
    - "Talon" would work in place of "Talon of Furious Concentration" (but not "talon" or "alon")
    - "Skull.*Doom" would work in place of "Skull of Impending Doom" (assuming of course that no other item matches this regex)
    - ".*Doom" would work in place of "Skull of Impending Doom" (assuming of course that no other item matches this regex)

- getItemName(itemLink)
Function to take an item link and extract the item name. Helper to isInBag(itemName) for comparing names of container items.

- isBuffTextureActive(texture)
Function similar to isBuffNameActive(buff) but for texture names but more limited in that it only returns true/false based on if the texture name is active on the player.

- printBuffTextures()
Helper function to print active buff texture names/paths to chat for debugging and macro authoring.
For example:

<code>/script printBuffTextures()</code>

(Older docs or macros may refer to this helper as `getBuffTextures()`. The exported function name is `printBuffTextures()`.)

- Fish(pole)
One button to equip a fishing pole or begin fishing if a pole is equipped. Hold a modifier key (ctrl, alt, shift) + button to attach the best available lure in inventory.
For example, the following macro command:

<code>/script Fish("Strong Fishing Pole")</code>

