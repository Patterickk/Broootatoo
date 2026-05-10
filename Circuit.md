# Circuit Rescue — Session Notes (2026-05-10)

## Summary of Work Completed

All changes were committed as commit `a79b2c8` — "Bar UI, title rename, upgrade overhaul, terrain, bigger sprites".

---

## Changes Made

### Title Rename
- `scenes/character_select.tscn` — `"BROOOTATOO"` → `"Circuit Rescue"`

### Sprite Scale Increases
| Scene | Node | Old | New |
|---|---|---|---|
| `scenes/entities/player.tscn` | AnimatedSprite2D | (1.5, 1.5) | (2.5, 2.5) |
| `scenes/entities/orc_basic.tscn` | AnimatedSprite2D | (1.4, 1.4) | (2.2, 2.2) |
| `scenes/entities/orc_fast.tscn` | AnimatedSprite2D | (1.1, 1.1) | (1.8, 1.8) |
| `scenes/entities/boss.tscn` | AnimatedSprite2D | (2.5, 2.5) | (3.5, 3.5) |

### HUD Bar UI
- `scenes/ui/hud.tscn` — Replaced `ProgressBar` nodes with `TextureProgressBar` using Tiny Swords assets:
  - HealthBar: `BigBar_Base.png` (under) + `BigBar_Fill.png` (progress), size 256×28, stretch margins 68
  - XPBar: `SmallBar_Base.png` (under) + `SmallBar_Fill.png` (progress), size 220×18, stretch margins 54
- `src/ui/HUD.gd` — Updated type annotations to `TextureProgressBar`

### Terrain
- `scenes/game.tscn`:
  - `Floor` node: ColorRect → `TextureRect` using `Tilemap_color1.png` with `stretch_mode = 3` (STRETCH_TILE), covers full arena (-1280,-720 to 1280,720) — hedge/bush border ring
  - `Border` node (inner playing field): kept as `ColorRect`, color `Color(0.27, 0.48, 0.17, 1)` (grass green)

### Upgrade System Overhaul
- `src/Game.gd`:
  - Upgrade trigger moved from wave completion → player level-up
  - `player.level_up.connect(_on_player_level_up)` added in `_spawn_player()`
  - `_on_wave_completed()` now auto-starts next wave after 1.5s delay
  - `_on_upgrade_chosen()` is now a no-op (upgrade UI handles unpausing)

- `src/ui/UpgradeUI.gd` — New 9-option upgrade pool:
  - `+1 Arrow` — extra arrow per shot (max 4 extra)
  - `Pierce` — arrows pass through one extra enemy
  - `+0.3 Fire Rate` — capped at 5.0/s
  - `+60 Arrow Speed`
  - `+15 Damage`
  - `+20 Max HP` (also restores HP)
  - `+2 Armor`
  - `+20 Speed`
  - `+5% Dodge` (capped at 75%)

### Arrow Pierce
- `src/weapons/Arrow.gd`:
  - Added `_pierce_remaining: int = 0`
  - `launch()` now accepts `pierce: int = 0` parameter
  - `_on_body_entered()` only calls `queue_free()` when `_pierce_remaining <= 0`; otherwise decrements

### Multi-Arrow Spread Fire
- `src/weapons/ArrowWeapon.gd`:
  - Added `extra_arrows: int = 0` and `arrow_pierce: int = 0`
  - `fire()` fires `1 + extra_arrows` arrows at 12° angular spread around base direction
  - Each arrow passes `arrow_pierce` to its `launch()` call

---

## Technical Notes

- `TextureProgressBar` inherits from `Range` — same `max_value`/`value` API as `ProgressBar`, no HUD.gd logic changes needed
- Tilemap_color1.png is 576×384px (9×6 tiles at 64×64px) — contains hedge/bush wall tiles, not flat ground
- WaveManager: calling `start_next_wave()` past MAX_WAVES emits `all_waves_completed` and returns — wave 20 → win condition works correctly with auto-advance
- Bar UIDs: BigBar_Base `uid://dykx1rhjjkge0`, BigBar_Fill `uid://bghmdler6ka2k`, SmallBar_Base `uid://d33afqvcw4pgj`, SmallBar_Fill `uid://bciy4aptu2oc8`

---

## Pending / Future Work

- Bar stretch margins and sizes may need visual tweaking once seen in-game
- Terrain atlas tile coordinates could be refined with a proper TileMapLayer setup (user referenced Tiny Swords tilemap guide)
- Git push to remote not yet done
