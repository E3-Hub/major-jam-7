extends Node
class_name PatchSystem

signal patch_applied(patch_data: Dictionary)

@export var min_patch_interval: float = 1000.0
@export var max_patch_interval: float = 1000.0

@onready var patch_timer: Timer = $PatchTimer

var game_manager: GameManager
var enemy_spawner: EnemySpawner
var player: Player
var patch_count: int = 0

# Global patch effect modifiers are now in GameModifiers autoload

# Patch generation data
var patch_types = [
	{
		"effect": "enemy_health_buff",
		"name": "Enemy Health",
		"positive_descriptions": ["Fixed enemy health being too low", "Enemies were too weak", "Buffed enemy survivability"],
		"negative_descriptions": ["Enemies are now tankier", "Health exploit patched", "Survival difficulty increased"],
		"change_templates": ["• Increased enemy health by {value}%", "• Enemy HP boosted by {value}%", "• Enemies now {value}% more durable"]
	},
	{
		"effect": "spawn_rate_increase",
		"name": "Spawn Rate",
		"positive_descriptions": ["Game was too easy", "Players requested more action", "Increased enemy presence"],
		"negative_descriptions": ["Spawn rate exploit fixed", "Performance optimization", "Balanced enemy encounters"],
		"change_templates": ["• Reduced spawn timer by {value}%", "• Enemies spawn {value}% faster", "• Increased spawn frequency by {value}%"]
	},
	{
		"effect": "player_speed_nerf",
		"name": "Player Speed",
		"positive_descriptions": ["Fixed player speed exploit", "Movement was too fast", "Balanced player mobility"],
		"negative_descriptions": ["Speed bug patched", "Movement system reworked", "Player agility adjusted"],
		"change_templates": ["• Reduced player speed by {value}%", "• Player movement slowed by {value}%", "• Fixed speed exploit (-{value}%)"]
	},
	{
		"effect": "enemy_speed_buff",
		"name": "Enemy Speed",
		"positive_descriptions": ["Improved enemy AI", "Enhanced enemy behavior", "Enemies too slow"],
		"negative_descriptions": ["AI pathfinding updated", "Enemy movement optimized", "Mobility enhancement"],
		"change_templates": ["• Enemies move {value}% faster", "• Increased enemy speed by {value}%", "• Enhanced enemy mobility (+{value}%)"]
	},
	{
		"effect": "player_damage_buff",
		"name": "Player Damage",
		"positive_descriptions": ["Players complained bullets too weak", "Damage was underwhelming", "Combat felt unsatisfying"],
		"negative_descriptions": ["Weapon balance improved", "Damage scaling fixed", "Combat enhancement"],
		"change_templates": ["• Increased player damage by {value}%", "• Bullets now deal {value}% more damage", "• Weapon damage boosted by {value}%"]
	},
	{
		"effect": "enemy_damage_nerf",
		"name": "Enemy Damage",
		"positive_descriptions": ["Game was too hard", "Enemy damage too high", "Player survivability improved"],
		"negative_descriptions": ["Damage balance adjusted", "Enemy weapons nerfed", "Combat difficulty reduced"],
		"change_templates": ["• Reduced enemy damage by {value}%", "• Enemy bullets weakened by {value}%", "• Damage output decreased by {value}%"]
	},
	{
		"effect": "bullet_speed_buff",
		"name": "Bullet Speed",
		"positive_descriptions": ["Optimized projectile system", "Performance improvements", "Bullet physics enhanced"],
		"negative_descriptions": ["Projectile speed increased", "Ballistics system updated", "Faster combat pace"],
		"change_templates": ["• Bullets move {value}% faster", "• Projectile speed increased by {value}%", "• Enhanced bullet velocity (+{value}%)"]
	},
	{
		"effect": "player_fire_rate_buff",
		"name": "Fire Rate",
		"positive_descriptions": ["Community requested faster shooting", "Fire rate too slow", "Combat pacing improved"],
		"negative_descriptions": ["Weapon cooldown reduced", "Shooting mechanics enhanced", "Rapid fire enabled"],
		"change_templates": ["• Shooting speed increased by {value}%", "• Fire rate boosted by {value}%", "• Reduced shooting cooldown by {value}%"]
	},
	{
		"effect": "exp_nerf",
		"name": "Experience Gain",
		"positive_descriptions": ["Fixed experience exploit", "Leveling too fast", "Progression rebalanced"],
		"negative_descriptions": ["XP gain normalized", "Level curve adjusted", "Progression difficulty increased"],
		"change_templates": ["• Reduced EXP gain by {value}%", "• Experience rewards decreased by {value}%", "• Leveling slowed by {value}%"]
	},
	{
		"effect": "spawn_distance_nerf",
		"name": "Spawn Distance",
		"positive_descriptions": ["Enemies spawn too far", "Increased encounter rate", "More aggressive spawning"],
		"negative_descriptions": ["Spawn system reworked", "Enemy positioning improved", "Combat intensity increased"],
		"change_templates": ["• Enemies spawn {value}% closer", "• Reduced spawn distance by {value}%", "• Tighter enemy spawning ({value}% closer)"]
	}
]

var patch_titles = [
	"Hotfix v{major}.{minor}.{patch}",
	"Balance Update v{major}.{minor}.{patch}",
	"Emergency Patch v{major}.{minor}.{patch}",
	"Content Update v{major}.{minor}.{patch}",
	"Performance Update v{major}.{minor}.{patch}",
	"Community Request v{major}.{minor}.{patch}",
	"Bugfix v{major}.{minor}.{patch}",
	"Experimental Patch v{major}.{minor}.{patch}",
	"Developer Response v{major}.{minor}.{patch}",
	"Critical Update v{major}.{minor}.{patch}"
]

var funny_additions = [
	"Good luck!",
	"This might break everything",
	"We're not sorry",
	"Deal with it",
	"Working as intended",
	"Oops",
	"You asked for this",
	"Blame the community",
	"RNG gods have spoken",
	"Perfectly balanced"
]

var version_major: int = 1
var version_minor: int = 2
var version_patch: int = 0

func _ready():
	# Find game components
	game_manager = get_tree().get_first_node_in_group("game_manager")
	enemy_spawner = get_tree().get_first_node_in_group("enemy_spawner")
	player = get_tree().get_first_node_in_group("player")
	
	# Setup patch timer
	patch_timer.wait_time = randf_range(min_patch_interval, max_patch_interval)
	patch_timer.one_shot = true
	patch_timer.timeout.connect(_on_patch_timer_timeout)
	patch_timer.start()

func _on_patch_timer_timeout():
	apply_random_patch()
	
	# Schedule next patch
	patch_timer.wait_time = randf_range(min_patch_interval, max_patch_interval)
	patch_timer.start()

func generate_random_patch() -> Dictionary:
	# Pick random patch type
	var patch_type = patch_types[randi() % patch_types.size()]
	
	# Generate random value based on effect type
	var value = generate_random_value(patch_type.effect)
	var is_buff = is_effect_buff(patch_type.effect, value)
	
	# Pick description based on whether it's a buff or nerf
	var descriptions = patch_type.positive_descriptions if is_buff else patch_type.negative_descriptions
	var description = descriptions[randi() % descriptions.size()]
	
	# Generate version number
	increment_version()
	var title_template = patch_titles[randi() % patch_titles.size()]
	var title = title_template.format({
		"major": version_major,
		"minor": version_minor,
		"patch": version_patch
	})
	
	# Generate change text
	var change_template = patch_type.change_templates[randi() % patch_type.change_templates.size()]
	var change_text = change_template.format({"value": int((abs(value - 1.0)) * 100)})
	
	# Maybe add funny addition
	var changes = [change_text]
	if randf() < 0.3: # 30% chance
		changes.append("• " + funny_additions[randi() % funny_additions.size()])
	
	return {
		"title": title,
		"description": description,
		"changes": changes,
		"effect": patch_type.effect,
		"value": value
	}

func generate_random_value(effect: String) -> float:
	match effect:
		"enemy_health_buff":
			return randf_range(1.15, 1.5) # 15-50% increase
		"spawn_rate_increase":
			return randf_range(0.6, 0.9) # 10-40% faster spawning
		"player_speed_nerf":
			return randf_range(0.7, 0.9) # 10-30% slower
		"enemy_speed_buff":
			return randf_range(1.2, 1.6) # 20-60% faster
		"player_damage_buff":
			return randf_range(1.25, 2.0) # 25-100% more damage
		"enemy_damage_nerf":
			return randf_range(0.6, 0.85) # 15-40% less damage
		"bullet_speed_buff":
			return randf_range(1.3, 2.0) # 30-100% faster
		"player_fire_rate_buff":
			return randf_range(0.4, 0.8) # 20-60% faster fire rate
		"exp_nerf":
			return randf_range(0.5, 0.8) # 20-50% less exp
		"spawn_distance_nerf":
			return randf_range(0.4, 0.8) # 20-60% closer
		_:
			return 1.0

func is_effect_buff(effect: String, value: float) -> bool:
	# Determine if this is generally positive for the player
	match effect:
		"enemy_health_buff", "spawn_rate_increase", "player_speed_nerf", "enemy_speed_buff", "exp_nerf", "spawn_distance_nerf":
			return false # These are nerfs/challenges
		"player_damage_buff", "enemy_damage_nerf", "bullet_speed_buff", "player_fire_rate_buff":
			return true # These are buffs
		_:
			return value > 1.0

func increment_version():
	version_patch += 1
	if version_patch > 9:
		version_patch = 0
		version_minor += 1
		if version_minor > 9:
			version_minor = 0
			version_major += 1

func apply_random_patch():
	var patch = generate_random_patch()
	patch_count += 1
	
	# Apply the patch effect
	apply_patch_effect(patch)
	
	# Show patch notes UI
	show_patch_notes(patch)
	
	patch_applied.emit(patch)

func apply_patch_effect(patch: Dictionary):
	match patch.effect:
		"enemy_health_buff":
			modify_all_enemies_health(patch.value)
			GameModifiers.apply_modifier("enemy_health", patch.value)
		"spawn_rate_increase":
			if enemy_spawner:
				enemy_spawner.base_spawn_interval *= patch.value
			GameModifiers.apply_modifier("enemy_spawn_rate", patch.value)
		"player_speed_nerf":
			if player:
				player.speed *= patch.value
			GameModifiers.apply_modifier("player_speed", patch.value)
		"enemy_speed_buff":
			modify_all_enemies_speed(patch.value)
			GameModifiers.apply_modifier("enemy_speed", patch.value)
		"player_damage_buff":
			GameModifiers.apply_modifier("player_damage", patch.value)
		"enemy_damage_nerf":
			GameModifiers.apply_modifier("enemy_damage", patch.value)
		"bullet_speed_buff":
			GameModifiers.apply_modifier("bullet_speed", patch.value)
		"player_fire_rate_buff":
			if player:
				player.shoot_cooldown *= patch.value
			GameModifiers.apply_modifier("player_fire_rate", patch.value)
		"exp_nerf":
			modify_all_enemies_exp(patch.value)
			GameModifiers.apply_modifier("experience", patch.value)
		"spawn_distance_nerf":
			if enemy_spawner:
				enemy_spawner.spawn_distance *= patch.value
			GameModifiers.apply_modifier("enemy_spawn_distance", patch.value)

func modify_all_enemies_health(multiplier: float):
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy.has_method("apply_health_modifier"):
			enemy.apply_health_modifier(multiplier)

func modify_all_enemies_speed(multiplier: float):
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy.has_method("apply_speed_modifier"):
			enemy.apply_speed_modifier(multiplier)

func modify_all_enemies_exp(multiplier: float):
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy.has_method("apply_exp_modifier"):
			enemy.apply_exp_modifier(multiplier)

func show_patch_notes(patch: Dictionary):
	# This will be handled by the UI system
	if game_manager and game_manager.ui_manager:
		game_manager.ui_manager.show_patch_notes(patch)