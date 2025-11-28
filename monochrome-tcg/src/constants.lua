local Constants = {}

-- Playdate Resolution
Constants.SCREEN_WIDTH = 400
Constants.SCREEN_HEIGHT = 240

-- Game Boy Original Resolution (to be centered)
Constants.GB_WIDTH = 160
Constants.GB_HEIGHT = 144
Constants.OFFSET_X = (Constants.SCREEN_WIDTH - Constants.GB_WIDTH) / 2
Constants.OFFSET_Y = (Constants.SCREEN_HEIGHT - Constants.GB_HEIGHT) / 2

local gfx = playdate.graphics

-- Palette (Mapped to Patterns)
-- White -> kColorWhite
-- Light -> Light Dither
-- Dark -> Dark Dither
-- Black -> kColorBlack

Constants.COLORS = {
    WHITE = gfx.kColorWhite,
    LIGHT = {0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55}, -- 50% Gray (Checkerboard)
    DARK = {0xFF, 0xDD, 0xFF, 0x77, 0xFF, 0xDD, 0xFF, 0x77}, -- Darker Dither (75% Black? No, this is custom)
    -- Let's use standard patterns for simplicity
    LIGHT_PATTERN = gfx.kColorClear, -- Placeholder, will define properly
    DARK_PATTERN = gfx.kColorClear,
    BLACK = gfx.kColorBlack
}

-- Redefine patterns properly
Constants.PATTERNS = {
    LIGHT = {0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA}, -- 50% Dither
    DARK = {0x77, 0xDD, 0x77, 0xDD, 0x77, 0xDD, 0x77, 0xDD}   -- Darker Dither
}

return Constants
