extends Node2D
class_name EnemySpawner

@export var enemy_scenes: Array[PackedScene] = []
@export var spawn_interval: float = 1.0
@export var spawn_wave_interval: float = 15.0
@export var spawn_outside_margin: float = 100.0
@export var spawn_inside_margin: float = 100.0

var spawn_timer: Timer
var spawn_wave_timer: Timer

var player: Player
var current_level: int = 1
var enemies_spawned: int = 0

var current_spawn_side: int = 0
var current_spawn_color: int = EnemyColorType.RED

func _ready():
	# Find player
	player = get_tree().get_first_node_in_group("player")
	player.experience_system.level_up.connect(_on_player_level_up)
	
	# Setup spawn timer
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

	spawn_wave_timer = Timer.new()
	add_child(spawn_wave_timer)
	spawn_wave_timer.wait_time = spawn_wave_interval
	spawn_wave_timer.timeout.connect(_on_spawn_wave_timeout)
	spawn_wave_timer.start()

func _on_spawn_timer_timeout():
	spawn_enemy()

func _on_spawn_wave_timeout():
	current_spawn_side = randi() % 4
	current_spawn_color = randi() % 3

func spawn_enemy():
	if not player or enemy_scenes.is_empty():
		return
	
	# Choose random enemy type
	var enemy_scene = enemy_scenes[randi() % GameModifiers.enemy_type_level]
	var enemy: BaseEnemy = enemy_scene.instantiate()
	
	# Check if it's a CannonEnemy for special spawn handling
	var spawn_pos: Vector2
	if enemy is CannonEnemy:
		spawn_pos = get_cannon_spawn_position()
	else:
		spawn_pos = get_spawn_position()
	
	enemy.global_position = spawn_pos
	
	# Connect enemy death signal
	enemy.enemy_died.connect(_on_enemy_died)
	
	# Add to scene
	get_tree().current_scene.add_child(enemy)
	enemies_spawned += 1

	enemy.setup(current_spawn_color)

func get_spawn_position() -> Vector2:
	# Get screen size
	var viewport = get_viewport()
	var screen_size = viewport.get_visible_rect().size
	var spawn_pos = Vector2.ZERO
	
	match current_spawn_side:
		0: # Top
			spawn_pos = Vector2(randf_range(0, screen_size.x), -spawn_outside_margin)
		1: # Right
			spawn_pos = Vector2(screen_size.x + spawn_outside_margin, randf_range(0, screen_size.y))
		2: # Bottom
			spawn_pos = Vector2(randf_range(0, screen_size.x), screen_size.y + spawn_outside_margin)
		3: # Left
			spawn_pos = Vector2(-spawn_outside_margin, randf_range(0, screen_size.y))
	
	# Convert to world position relative to camera
	var camera = get_viewport().get_camera_2d()
	if camera:
		spawn_pos += camera.global_position - screen_size / 2
	
	return spawn_pos

func get_cannon_spawn_position() -> Vector2:
	# Spawn cannon enemies within the visible screen area
	var viewport = get_viewport()
	var screen_size = viewport.get_visible_rect().size
	var camera = get_viewport().get_camera_2d()
	
	# Create a margin so cannons don't spawn too close to screen edges
	var spawn_pos = Vector2(
		randf_range(spawn_inside_margin, screen_size.x - spawn_inside_margin),
		randf_range(spawn_inside_margin, screen_size.y - spawn_inside_margin)
	)
	
	# Convert to world position relative to camera
	if camera:
		spawn_pos += camera.global_position - screen_size / 2
	
	return spawn_pos

func _on_player_level_up(new_level: int):
	current_level = new_level
	print("Enemy spawner: Player reached level ", new_level, ". Increasing difficulty!")

func _on_enemy_died(enemy: BaseEnemy):
	# Handle enemy death if needed
	pass
