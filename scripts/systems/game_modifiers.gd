extends Node

# Global game modifiers that can be accessed from anywhere
# This is an autoload singleton

# Damage modifiers
var player_damage_modifier: float = 1.0
var enemy_damage_modifier: float = 1.0

# Speed modifiers
var player_speed_modifier: float = 1.0
var enemy_speed_modifier: float = 1.0
var bullet_speed_modifier: float = 1.0

# Combat modifiers
var player_fire_rate_modifier: float = 1.0
var enemy_fire_rate_modifier: float = 1.0

# Spawn modifiers
var enemy_spawn_rate_modifier: float = 1.0
var enemy_spawn_distance_modifier: float = 1.0

# Experience modifiers
var experience_modifier: float = 1.0

# Health modifiers
var enemy_health_modifier: float = 1.0

# Special modes
var bullet_chaos_mode: bool = false

# Apply a modifier to a specific stat
func apply_modifier(stat: String, value: float):
	match stat:
		"player_damage":
			player_damage_modifier *= value
		"enemy_damage":
			enemy_damage_modifier *= value
		"player_speed":
			player_speed_modifier *= value
		"enemy_speed":
			enemy_speed_modifier *= value
		"bullet_speed":
			bullet_speed_modifier *= value
		"player_fire_rate":
			player_fire_rate_modifier *= value
		"enemy_fire_rate":
			enemy_fire_rate_modifier *= value
		"enemy_spawn_rate":
			enemy_spawn_rate_modifier *= value
		"enemy_spawn_distance":
			enemy_spawn_distance_modifier *= value
		"experience":
			experience_modifier *= value
		"enemy_health":
			enemy_health_modifier *= value

# Reset all modifiers to default
func reset_all_modifiers():
	player_damage_modifier = 1.0
	enemy_damage_modifier = 1.0
	player_speed_modifier = 1.0
	enemy_speed_modifier = 1.0
	bullet_speed_modifier = 1.0
	player_fire_rate_modifier = 1.0
	enemy_fire_rate_modifier = 1.0
	enemy_spawn_rate_modifier = 1.0
	enemy_spawn_distance_modifier = 1.0
	experience_modifier = 1.0
	enemy_health_modifier = 1.0
	bullet_chaos_mode = false

# Get a summary of all current modifiers
func get_modifier_summary() -> Dictionary:
	return {
		"player_damage": player_damage_modifier,
		"enemy_damage": enemy_damage_modifier,
		"player_speed": player_speed_modifier,
		"enemy_speed": enemy_speed_modifier,
		"bullet_speed": bullet_speed_modifier,
		"player_fire_rate": player_fire_rate_modifier,
		"enemy_fire_rate": enemy_fire_rate_modifier,
		"enemy_spawn_rate": enemy_spawn_rate_modifier,
		"enemy_spawn_distance": enemy_spawn_distance_modifier,
		"experience": experience_modifier,
		"enemy_health": enemy_health_modifier,
		"bullet_chaos_mode": bullet_chaos_mode
	}