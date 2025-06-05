extends BaseEnemy
class_name DashingEnemy

@export var dash_range: float = 400.0
@export var dash_prepare_time: float = 2.0
@export var dash_speed: float = 600.0
@export var dash_distance: float = 600.0
@export var dash_damage: int = 25
@export var reflect_knockback_force: float = 300.0

@onready var dash_timer: Timer = $DashTimer
@onready var dash_attack_area: Area2D = $DashAttackArea
@onready var ghost_trail_effect: GhostTrailEffect = $GhostTrailEffect

enum DashState {
	APPROACHING,
	PREPARING,
	DASHING
}

var current_state: DashState = DashState.APPROACHING
var dash_direction: Vector2
var dash_start_position: Vector2
var original_speed: float

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
	ghost_trail_effect.color = EnemyColorType.get_ghost_color(enemy_color)
	ghost_trail_effect.start_effect()

func end_dash():
	current_state = DashState.APPROACHING
	velocity = Vector2.ZERO
	
	# Disable dash attack detection
	dash_attack_area.monitoring = false
	
	# Stop creating ghosts
	ghost_trail_effect.stop_effect()

func _on_dash_timer_timeout():
	start_dash()

func _on_dash_attack_area_body_entered(body):
	if body is Player and current_state == DashState.DASHING:
		body.take_damage(dash_damage)
		end_dash()
		knockback_system.apply_knockback(-dash_direction * reflect_knockback_force)
