-- Project forked from existing repair mod https://steamcommunity.com/sharedfiles/filedetails/?id=2852867235&searchtext=better+repair
-- Docs https://projectzomboid.com/modding/zombie/characters/package-summary.html
local ISFixAction_perform = ISFixAction.perform

local function luckyCharm()
    local chance = SandboxVars.PRM.stopCounterChance
    if chance == 0 then return false end
    local a = ZombRand(0, 101)
    local b = 100 - chance
    return a >= b
end

-- Magic way to determine if we're repairing a vehicle part or not. Would prefer a 
-- more explicit way to do this, but this works for now.
local function isVehicleRepair(vehiclePart) return vehiclePart and isClient() end

-- Given a perkLevel and an item, returns the new repaired count for this item
local function getNewRepairedCount(perkLevel, item)
    local n = item:getHaveBeenRepaired() - 1

    -- Since we're repairing, n should always be at least 1
    if n <= 0 then n = 1 end

    -- Some special sauce, if our perkLevel is equal to the reset counter sandbox var, we set n back to 1
    if perkLevel == SandboxVars.PRM.perkLevelResetCounter then n = 1 end
    return n
end

-- Given a perkLevel and an item, returns true if the item was repaired, false otherwise
local function fixItem(perkLevel, item)
    if perkLevel >= SandboxVars.PRM.perkFreezeCounter or luckyCharm() then
        local n = getNewRepairedCount(perkLevel, item)
        item:setHaveBeenRepaired(n)
    end
end

local function fixVehiclePart(perkLevel, item, vehiclePart, char)
    if perkLevel >= SandboxVars.PRM.perkFreezeCounter or luckyCharm() then
        local n = getNewRepairedCount(perkLevel, item)
        item:setHaveBeenRepaired(n)
        local args = {
            vehicle = vehiclePart:getVehicle():getId(),
            part = vehiclePart:getId(),
            condition = item:getCondition(),
            haveBeenRepaired = n
        }
        sendClientCommand(char, 'vehicle', 'fixPart', args)
    end
end

local function customRepairLogic()
    local char = self.character
    local item = self.item
    local vehiclePart = self.vehiclePart

    if isVehicleRepair(vehiclePart) then
        local perkLevel = char:getPerkLevel(Perks.Mechanics)
        fixVehiclePart(perkLevel, item, vehiclePart, char)
    else
        local perkLevel = char:getPerkLevel(Perks.Maintenance)
        fixItem(perkLevel, item)
    end
end

function ISFixAction:perform()
    ISFixAction_perform(self)

    -- Custom repair logic happens after the default repair logic
    customRepairLogic()
end