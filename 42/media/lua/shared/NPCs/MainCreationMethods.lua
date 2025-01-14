ProfessionFramework.addTrait('Nightmares', {
    name = "UI_trait_nightmares",
    description = "UI_trait_nightmaresdesc",
    exclude = {"Desensitized"},
    cost = -4,
    requiresSleepEnabled = true,
    inventory = {
        -- starting kit to help get back to sleep
        ["Base.PillsBeta"] = 1,
        ["Base.PillsSleepingTablets"] = 1,
    },
    OnGameStart = function(trait)
        -- add a new event to trigger every ten minutes
        Events.EveryTenMinutes.Add(function()
            local p = getSpecificPlayer(0)
            if p:isAsleep() and ZombRand(100) < 2 then
                p:forceAwake()
                p:getStats():setPanic(90)
            end
        end)
    end
})