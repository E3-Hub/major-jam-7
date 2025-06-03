# Major Jam 7: Wild

- Theme: Wild
- Limitation: Unpredictable rules
- Period: 7 days

https://itch.io/jam/major-jam-7-wild

# add godot executable path in .vscode
```
{
    "files.exclude": {
        "**/*.uid": true
    },
    "godotTools.editorPath.godot4": "godot executable path"
} 
```
# 2D Top-Down Shooting Game

A scalable 2D top-down survival shooting game built in Godot 4.4.

## Features

- **Player Movement**: WASD controls for smooth movement
- **Mouse Shooting**: Hold left click to shoot at cursor position
- **Health System**: Both player and enemies have health
- **Experience System**: Collect EXP orbs to level up
- **Enemy AI**: Enemies spawn from screen edges with different attack patterns
- **Scalable Design**: Easy to add new enemy types and mechanics
- **Progressive Difficulty**: Enemy stats and spawn rates increase with player level

## Project Structure

```
scripts/
├── systems/          # Core game systems
│   ├── health_system.gd      # Reusable health component
│   ├── experience_system.gd  # Player leveling system
│   ├── bullet.gd            # Bullet behavior
│   ├── enemy_spawner.gd     # Enemy spawning system
│   ├── game_manager.gd      # Main game state manager
│   └── camera_follow.gd     # Camera following script
├── player/
│   └── player.gd            # Player controller
├── enemies/
│   ├── base_enemy.gd        # Base enemy class
│   └── shooting_enemy.gd    # Shooting enemy implementation
├── ui/
│   └── ui_manager.gd        # UI system
└── world/
    └── exp_orb.gd           # Experience orb pickup

scenes/
├── player/          # Player scenes
├── enemies/         # Enemy scenes
├── ui/             # UI scenes
└── world/          # World objects and main scene
```

## Controls

- **WASD**: Move player
- **Left Mouse Button**: Shoot (hold for continuous fire)

## Game Mechanics

### Health System

- Both player and enemies use the same health system component
- Health bars show current health status
- Game ends when player health reaches zero

### Experience System

- Enemies drop EXP orbs when defeated
- Player automatically collects nearby orbs
- Leveling up increases enemy difficulty and spawn rate

### Enemy System

- Enemies spawn randomly from screen edges
- Base enemy class allows easy creation of new enemy types
- Current implementation includes shooting enemies that move toward player and fire projectiles

### Collision Layers

1. Player
2. Enemy
3. Player Bullets
4. Enemy Bullets
5. Experience Orbs

## Adding New Features

### New Enemy Types

1. Create a new script extending `BaseEnemy`
2. Override the `update_ai(delta)` method
3. Create a scene with the new enemy script
4. Add the scene to the EnemySpawner's enemy_scenes array

### New Weapons/Abilities

1. Modify the player's shooting system
2. Create new bullet types by extending the Bullet class
3. Add weapon switching logic to the player controller

### Power-ups/Perks

1. Create new pickup objects similar to ExpOrb
2. Add perk selection UI on level up
3. Implement perk effects in the player or game systems

## Next Steps for Development

1. **Art Assets**: Replace ColorRect placeholders with sprites
2. **Audio**: Add sound effects and background music
3. **Boss System**: Create boss enemies with unique patterns
4. **Perk System**: Add upgrades and abilities on level up
5. **More Enemy Types**: Implement different AI behaviors
6. **Particle Effects**: Add visual feedback for hits, explosions, etc.
7. **Save System**: Track high scores and unlockables
