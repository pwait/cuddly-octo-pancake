# Monochrome TCG Prototype (Playdate Port)

I have ported the monochrome card game prototype to the Playdate SDK.

## Features
- **Playdate Native**: Runs at 400x240 resolution.
- **1-bit Graphics**: Uses dither patterns to simulate the original 4-color palette.
- **Card System**: Basic support for Pokemon and Energy cards.
- **Battle System**:
    -   Draw cards from deck.
    -   Play Basic Pokemon to Active or Bench slots.
    -   Attack the opponent's Active Pokemon.
    -   Win condition (Defeat opponent's Active Pokemon).

## How to Run
1.  Ensure you have the [Playdate SDK](https://play.date/dev/) installed.
2.  Navigate to the project folder:
    ```bash
    cd ~/Documents/cuddly-octo-pancake/monochrome-tcg
    ```
3.  Compile the game:
    ```bash
    pdc . MonochromeTCG.pdx
    ```
4.  Open `MonochromeTCG.pdx` in the Playdate Simulator.

## Controls
-   **D-pad**: Move cursor (Left/Right in Hand, Up/Down between Hand and Board).
-   **A Button**: Select / Play Card / Attack.
-   **B Button**: (Unused)

## Project Structure
-   `main.lua`: Entry point, handles update loop.
-   `pdxinfo`: Playdate metadata.
-   `src/constants.lua`: Palette patterns and screen constants.
-   `src/card_db.lua`: Database of cards.
-   `src/battle_state.lua`: Core game logic adapted for Playdate input.
-   `src/renderer.lua`: Drawing functions using `playdate.graphics`.
