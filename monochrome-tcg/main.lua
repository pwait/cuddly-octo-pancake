local Constants = require "src.constants"
local BattleState = require "src.battle_state"

local game_state = nil

function init()
    -- Initialize Battle State
    game_state = BattleState.new()
end

init()

function playdate.update()
    if game_state then
        game_state:update()
        game_state:draw_screen()
    end
end
