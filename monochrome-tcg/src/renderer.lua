local Constants = require "src.constants"
local gfx = playdate.graphics

local Renderer = {}

function Renderer.drawCard(card, x, y)
    -- Apply Offset
    x = x + Constants.OFFSET_X
    y = y + Constants.OFFSET_Y

    -- Draw card background (White)
    gfx.setColor(Constants.COLORS.WHITE)
    gfx.fillRect(x, y, 40, 56)
    
    -- Draw card border (Black)
    gfx.setColor(Constants.COLORS.BLACK)
    gfx.drawRect(x, y, 40, 56)
    
    -- Draw card name (truncated)
    gfx.drawText(string.sub(card.name, 1, 6), x + 2, y + 2)
    
    -- Draw HP if pokemon
    if card.type == "pokemon" then
        gfx.drawText(tostring(card.hp), x + 25, y + 2)
    end
    
    -- Draw Element Icon (Placeholder with Patterns)
    if card.element == "grass" then
        gfx.setPattern(Constants.PATTERNS.LIGHT)
        gfx.fillRect(x + 2, y + 12, 8, 8)
    elseif card.element == "fire" then
        gfx.setPattern(Constants.PATTERNS.DARK)
        gfx.fillCircleAtPoint(x + 8, y + 18, 4)
    elseif card.element == "water" then
        gfx.setColor(Constants.COLORS.BLACK)
        -- Draw triangle manually or use polygon if available, simple rect for now
        gfx.fillRect(x + 2, y + 12, 8, 8)
    end
    
    -- Reset color
    gfx.setColor(Constants.COLORS.BLACK)
end

return Renderer
