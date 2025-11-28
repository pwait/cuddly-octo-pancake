local CardDB = {}

CardDB.Types = {
    POKEMON = "pokemon",
    ENERGY = "energy",
    TRAINER = "trainer"
}

CardDB.Elements = {
    NORMAL = "normal",
    GRASS = "grass",
    FIRE = "fire",
    WATER = "water"
}

CardDB.Cards = {
    -- Energy
    grass_energy = {
        id = "grass_energy",
        name = "Grass Energy",
        type = "energy",
        element = "grass"
    },
    fire_energy = {
        id = "fire_energy",
        name = "Fire Energy",
        type = "energy",
        element = "fire"
    },
    water_energy = {
        id = "water_energy",
        name = "Water Energy",
        type = "energy",
        element = "water"
    },

    -- Pokemon
    bulbasaur = {
        id = "bulbasaur",
        name = "Bulbasaur",
        type = "pokemon",
        element = "grass",
        hp = 40,
        attacks = {
            {name = "Tackle", cost = {"normal"}, damage = 10},
            {name = "Vine Whip", cost = {"grass", "normal"}, damage = 20}
        },
        weakness = "fire",
        resistance = "water",
        retreat_cost = 1
    },
    charmander = {
        id = "charmander",
        name = "Charmander",
        type = "pokemon",
        element = "fire",
        hp = 50,
        attacks = {
            {name = "Scratch", cost = {"normal"}, damage = 10},
            {name = "Ember", cost = {"fire", "normal"}, damage = 30}
        },
        weakness = "water",
        resistance = nil,
        retreat_cost = 1
    },
    squirtle = {
        id = "squirtle",
        name = "Squirtle",
        type = "pokemon",
        element = "water",
        hp = 40,
        attacks = {
            {name = "Bubble", cost = {"water"}, damage = 10},
            {name = "Water Gun", cost = {"water", "normal"}, damage = 20}
        },
        weakness = "grass",
        resistance = "fire",
        retreat_cost = 1
    }
}

function CardDB.getCard(id)
    return CardDB.Cards[id]
end

return CardDB
