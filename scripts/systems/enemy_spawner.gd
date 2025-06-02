extends Node2D
class_name EnemySpawner

@export var enemy_scenes: Array[PackedScene] = []
@export var base_spawn_interval: float = 3.0
@export var spawn_distance: float = 600.0

@onready var spawn_timer: Timer = $SpawnTimer

var player: Player
var current_level: int = 1
var enemies_spawned: int = 0

func _ready():
	# Find player
	player = get_tree().get_first_node_in_group("player")
	
	if player:
		player.experience_system.level_up.connect(_on_player_level_up)
	
	# Setup spawn timer
	spawn_timer.wait_time = base_spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _on_spawn_timer_timeout():
	spawn_enemy()
	
	# Adjust spawn rate based on level
	var level_multiplier = 1.0 - (current_level - 1) * 0.1
	level_multiplier = max(level_multiplier, 0.3) # Don't go below 30% of base interval
	spawn_timer.wait_time = base_spawn_interval * level_multiplier

func spawn_enemy():
	if not player or enemy_scenes.is_empty():
		return
	
	# Choose random enemy type
	var enemy_scene = enemy_scenes[randi() % enemy_scenes.size()]
	var enemy = enemy_scene.instantiate()
	
	# Get spawn position at screen edge
	var spawn_pos = get_spawn_position()
	enemy.global_position = spawn_pos
	
	# Scale enemy stats based on level
	scale_enemy_for_level(enemy)
	
	# Connect enemy death signal
	enemy.enemy_died.connect(_on_enemy_died)
	
	# Add to scene
	get_tree().current_scene.add_child(enemy)
	enemies_spawned += 1

func get_spawn_position() -> Vector2:
	if not player:
		return Vector2.ZERO
	
	# Get screen size
	var viewport = get_viewport()
	var screen_size = viewport.get_visible_rect().size
	
	# Choose random edge (0=top, 1=right, 2=bottom, 3=left)
	var edge = randi() % 4
	var spawn_pos = Vector2.ZERO
	
	match edge:
		0: # Top
			spawn_pos = Vector2(randf_range(0, screen_size.x), -spawn_distance)
		1: # Right
			spawn_pos = Vector2(screen_size.x + spawn_distance, randf_range(0, screen_size.y))
		2: # Bottom
			spawn_pos = Vector2(randf_range(0, screen_size.x), screen_size.y + spawn_distance)
		3: # Left
			spawn_pos = Vector2(-spawn_distance, randf_range(0, screen_size.y))
	
	# Convert to world position relative to camera
	var camera = get_viewport().get_camera_2d()
	if camera:
		spawn_pos += camera.global_position - screen_size / 2
	
	return spawn_pos

func scale_enemy_for_level(enemy: BaseEnemy):
	# Increase enemy stats based on current level
	var level_multiplier = 1.0 + (current_level - 1) * 0.2
	
	if enemy.health_system:
		enemy.health_system.max_health = int(enemy.health_system.max_health * level_multiplier)
		enemy.health_system.current_health = enemy.health_system.max_health
	
	enemy.speed *= (1.0 + (current_level - 1) * 0.1)
	enemy.exp_value = int(enemy.exp_value * level_multiplier)

func _on_player_level_up(new_level: int):
	current_level = new_level
	print("Enemy spawner: Player reached level ", new_level, ". Increasing difficulty!")

func _on_enemy_died(enemy: BaseEnemy):
	# Handle enemy death if needed
	pass
