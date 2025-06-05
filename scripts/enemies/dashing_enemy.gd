extends BaseEnemy
class_name DashingEnemy

@export var dash_range: float = 400.0
@export var dash_prepare_time: float = 2.0
@export var dash_speed: float = 600.0
@export var dash_distance: float = 600.0
@export var dash_damage: int = 25
@export var reflect_knockback_force: float = 300.0
@export var ghost_interval: float = 0.05 # Time between ghost spawns
@export var ghost_fade_time: float = 0.2 # How long ghosts take to fade

@onready var dash_timer: Timer = $DashTimer
@onready var dash_attack_area: Area2D = $DashAttackArea
@onready var ghost_timer: Timer = $GhostTimer

enum DashState {
	APPROACHING,
	PREPARING,
	DASHING
}

var current_state: DashState = DashState.APPROACHING
var dash_direction: Vector2
var dash_start_position: Vector2
var original_speed: float
var active_ghosts: Array[Sprite2D] = []

func _ready():
	super._ready()
	
	# Store original speed
	original_speed = speed
	
	# Setup dash timer
	dash_timer.wait_time = dash_prepare_time
	dash_timer.one_shot = true
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	
	# Setup dash attack area
	dash_attack_area.body_entered.connect(_on_dash_attack_area_body_entered)
	dash_attack_area.monitoring = false # Only monitor during dash
	
	# Setup ghost timer
	ghost_timer.wait_time = ghost_interval
	ghost_timer.timeout.connect(_on_ghost_timer_timeout)
	
	# Connect to death signal to cleanup ghosts
	health_system.died.connect(_on_enemy_died)

func update_ai(delta):
	if not player:
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	match current_state:
		DashState.APPROACHING:
			handle_approaching(distance_to_player)
		
		DashState.PREPARING:
			handle_preparing()
		
		DashState.DASHING:
			handle_dashing(delta)

func handle_approaching(distance_to_player: float):
	# Move toward player
	move_towards_player(get_physics_process_delta_time())
	
	# Rotate sprite toward player (not the entire enemy)
	var direction_to_player = (player.global_position - global_position).normalized()
	sprite.rotation = direction_to_player.angle() + PI / 2
	
	# Check if in dash range
	if distance_to_player <= dash_range:
		start_dash_preparation()

func handle_preparing():
	# Stop moving and rotate sprite toward player
	velocity = Vector2.ZERO
	move_and_slide()
	
	# Keep rotating sprite toward player during preparation
	var direction_to_player = (player.global_position - global_position).normalized()
	sprite.rotation = direction_to_player.angle() + PI / 2

func handle_dashing(delta):
	# Move in locked direction at high speed
	var distance_traveled = dash_start_position.distance_to(global_position)
	
	if distance_traveled >= dash_distance:
		# Dash complete, return to approaching
		end_dash()
	else:
		# Continue dashing
		velocity = dash_direction * dash_speed
	
	move_and_slide()

func start_dash_preparation():
	current_state = DashState.PREPARING
	dash_timer.start()

func start_dash():
	dash_direction = (player.global_position - global_position).normalized()
	current_state = DashState.DASHING
	dash_start_position = global_position
	
	# Enable dash attack detection
	dash_attack_area.monitoring = true
	
	# Start ghost trail
	ghost_timer.start()

func end_dash():
	current_state = DashState.APPROACHING
	velocity = Vector2.ZERO
	
	# Disable dash attack detection
	dash_attack_area.monitoring = false
	
	# Stop creating ghosts
	ghost_timer.stop()

func create_ghost():
	# Create a ghost sprite copy
	var ghost = Sprite2D.new()
	ghost.texture = sprite.texture
	ghost.material = sprite.material.duplicate()
	ghost.material.set_shader_parameter("target_color", EnemyColorType.get_ghost_color(enemy_color))
	ghost.global_position = global_position
	ghost.rotation = sprite.rotation
	ghost.scale = sprite.scale
	
	# Add to scene
	get_tree().current_scene.add_child(ghost)
	active_ghosts.append(ghost)
	
	# Create fade out tween
	var tween = create_tween()
	tween.tween_property(ghost, "material:shader_parameter/target_color:a", 0.0, ghost_fade_time)
	tween.tween_callback(func():
		if ghost and is_instance_valid(ghost):
			ghost.queue_free()
			active_ghosts.erase(ghost)
	)

func _on_dash_timer_timeout():
	start_dash()

func _on_ghost_timer_timeout():
	if current_state == DashState.DASHING:
		create_ghost()

func _on_dash_attack_area_body_entered(body):
	if body is Player and current_state == DashState.DASHING:
		body.take_damage(dash_damage)
		end_dash()
		knockback_system.apply_knockback(-dash_direction * reflect_knockback_force)

func cleanup_ghosts():
	# Immediately remove all active ghosts
	for ghost in active_ghosts:
		if ghost and is_instance_valid(ghost):
			ghost.queue_free()
	active_ghosts.clear()
	
	# Stop ghost timer to prevent new ghosts
	ghost_timer.stop()

func _on_enemy_died():
	# Clean up ghosts when enemy dies
	cleanup_ghosts()
