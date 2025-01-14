if ProfessionFramework then
    ProfessionFramework.addTrait('Hunter', {
        name = "UI_prof_parkranger",
        description = "UI_trait_HunterDesc",
        cost = 8,
        xp = {
            [Perks.Aiming] = 2,
            [Perks.Trapping] = 3,
            [Perks.Sneak] = 4,
            [Perks.SmallBlade] = 5,
        },
        recipes = {"Make Stick Trap", "Make Snare Trap", "Make Wooden Cage Trap", "Make Trap Box", "Make Cage Trap"},        
    })
else
    print("ProfessionFramework not found")
end
