extends Node

# Global game modifiers that can be accessed from anywhere
# This is an autoload singleton

# Damage modifiers
var player_damage_modifier: float = 1.0
var match_color_damage_modifier: float = 2.0
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
var player_health_modifier: float = 1.0

# looting modifiers
var looting_modifier: float = 1.0

# Special modes
var bullet_chaos_mode: bool = false

# Patch power modifiers
var patch_power_modifier: float = 1.0

# Reset all modifiers to default
func reset_all_modifiers():
	player_damage_modifier = 1.0
	match_color_damage_modifier = 1.0
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
	player_health_modifier =1.0
	looting_modifier = 1.0
	bullet_chaos_mode = false
	patch_power_modifier = 1.0
