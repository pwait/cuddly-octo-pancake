local CardDB = require "src.card_db"
local Constants = require "src.constants"
local Renderer = require "src.renderer"

local BattleState = {}
BattleState.__index = BattleState

function BattleState.new()
    local self = setmetatable({}, BattleState)
    
    self.player = {
        deck = {},
        hand = {},
        active = nil,
        bench = {},
        discard = {},
        prizes = {}
    }
    
    self.opponent = {
        deck = {},
        hand = {},
        active = nil,
        bench = {},
        discard = {},
        prizes = {}
    }
    
    self.turn = 1
    self.phase = "setup" -- setup, draw, main, attack, end
    self.current_player = "player" -- player, opponent
    
    self.cursor = {
        area = "hand", -- hand, board
        index = 1
    }
    
    -- Debug: Initialize a test deck
    for i=1, 20 do
        table.insert(self.player.deck, CardDB.getCard("grass_energy"))
        table.insert(self.player.deck, CardDB.getCard("bulbasaur"))
    end
    
    self:shuffle(self.player.deck)
    self:draw(self.player, 7)
    
    -- Debug: Spawn opponent active
    self.opponent.active = CardDB.getCard("charmander")
    self.opponent.active.damage = 0
    
    return self
end

function BattleState:update()
    self:handleInput()
end

function BattleState:handleInput()
    if self.cursor.area == "hand" then
        if playdate.buttonJustPressed(playdate.kButtonLeft) then
            self.cursor.index = math.max(1, self.cursor.index - 1)
        elseif playdate.buttonJustPressed(playdate.kButtonRight) then
            self.cursor.index = math.min(#self.player.hand, self.cursor.index + 1)
        elseif playdate.buttonJustPressed(playdate.kButtonUp) then
            self.cursor.area = "board"
            self.cursor.index = 1 -- 1 = active
        elseif playdate.buttonJustPressed(playdate.kButtonA) then
            self:play_card(self.cursor.index)
        end
    elseif self.cursor.area == "board" then
        if playdate.buttonJustPressed(playdate.kButtonDown) then
            self.cursor.area = "hand"
            self.cursor.index = 1
        elseif playdate.buttonJustPressed(playdate.kButtonA) then
            if self.cursor.index == 1 and self.player.active then
                self:attack(self.player.active, self.opponent.active)
            end
        end
    end
end

function BattleState:play_card(index)
    local card = self.player.hand[index]
    if not card then return end
    
    if card.type == "pokemon" then
        -- Place on active if empty, else bench
        if not self.player.active then
            self.player.active = card
            table.remove(self.player.hand, index)
            self.cursor.index = math.min(#self.player.hand, self.cursor.index)
        elseif #self.player.bench < 5 then
            table.insert(self.player.bench, card)
            table.remove(self.player.hand, index)
            self.cursor.index = math.min(#self.player.hand, self.cursor.index)
        end
    end
end

function BattleState:attack(attacker, defender)
    if not attacker or not defender then return end
    
    -- Simple attack logic: Use first attack
    local attack = attacker.attacks[1]
    local damage = attack.damage
    
    -- Apply weakness/resistance (Simple version)
    if defender.weakness == attacker.element then
        damage = damage * 2
    end
    if defender.resistance == attacker.element then
        damage = damage - 20
    end
    
    defender.damage = (defender.damage or 0) + damage
    
    -- Check KO
    if defender.damage >= defender.hp then
        self.opponent.active = nil
        -- Win condition for prototype
        self.phase = "VICTORY"
    end
end

function BattleState:shuffle(deck)
    for i = #deck, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

function BattleState:draw(target, amount)
    for i=1, amount do
        if #target.deck > 0 then
            local card = table.remove(target.deck, 1)
            table.insert(target.hand, card)
        end
    end
end

function BattleState:draw_screen()
    local gfx = playdate.graphics
    
    -- Draw Background (Light Pattern)
    gfx.setPattern(Constants.PATTERNS.LIGHT)
    gfx.fillRect(0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT)
    
    -- Draw Game Area Background (White)
    gfx.setColor(Constants.COLORS.WHITE)
    gfx.fillRect(Constants.OFFSET_X, Constants.OFFSET_Y, Constants.GB_WIDTH, Constants.GB_HEIGHT)
    gfx.setColor(Constants.COLORS.BLACK)
    gfx.drawRect(Constants.OFFSET_X, Constants.OFFSET_Y, Constants.GB_WIDTH, Constants.GB_HEIGHT)

    -- Draw Opponent Active
    if self.opponent.active then
        Renderer.drawCard(self.opponent.active, 60, 10)
        -- Draw Damage
        if self.opponent.active.damage and self.opponent.active.damage > 0 then
            gfx.drawText(tostring(self.opponent.active.damage), Constants.OFFSET_X + 90, Constants.OFFSET_Y + 10)
        end
    end

    -- Draw Active Pokemon
    if self.player.active then
        local y = 80
        if self.cursor.area == "board" and self.cursor.index == 1 then
            y = y - 5 -- Highlight selection
        end
        Renderer.drawCard(self.player.active, 60, y)
    else
        gfx.setColor(Constants.COLORS.BLACK)
        gfx.drawRect(Constants.OFFSET_X + 60, Constants.OFFSET_Y + 80, 40, 56)
    end
    
    -- Draw Bench (Simple representation)
    for i, card in ipairs(self.player.bench) do
        Renderer.drawCard(card, 10 + (i-1) * 20, 140) -- Overlapping bench
    end

    -- Draw Hand
    local start_x = 10
    local start_y = 100 -- Fixed hand position
    
    for i, card in ipairs(self.player.hand) do
        local x = start_x + (i-1) * 20
        local y = 144 - 30 -- Bottom of screen
        
        -- Lift card if selected
        if self.cursor.area == "hand" and self.cursor.index == i then
            y = y - 10
        end
        
        Renderer.drawCard(card, x, y)
    end
    
    -- Draw UI Text
    gfx.drawText("Phase: " .. self.phase, Constants.OFFSET_X + 5, Constants.OFFSET_Y + 5)
    gfx.drawText("Deck: " .. #self.player.deck, Constants.OFFSET_X + 100, Constants.OFFSET_Y + 5)
    
    if self.phase == "VICTORY" then
        gfx.setColor(Constants.COLORS.WHITE)
        gfx.fillRect(Constants.OFFSET_X + 40, Constants.OFFSET_Y + 60, 80, 20)
        gfx.setColor(Constants.COLORS.BLACK)
        gfx.drawRect(Constants.OFFSET_X + 40, Constants.OFFSET_Y + 60, 80, 20)
        gfx.drawText("YOU WIN!", Constants.OFFSET_X + 45, Constants.OFFSET_Y + 62)
    end
end

return BattleState
