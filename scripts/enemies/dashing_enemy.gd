extends BaseEnemy
class_name DashingEnemy

@export var dash_range: float = 400.0
@export var dash_prepare_time: float = 2.0
@export var dash_speed: float = 1000.0
@export var dash_distance: float = 1000.0
@export var dash_damage: int = 25
@export var knockback_distance: float = 50.0

@onready var dash_timer: Timer = $DashTimer
@onready var dash_attack_area: Area2D = $DashAttackArea

enum DashState {
	APPROACHING,
	PREPARING,
	DASHING
}

var current_state: DashState = DashState.APPROACHING
var dash_direction: Vector2
var dash_start_position: Vector2
var original_speed: float
var has_hit_player: bool = false

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
	
	# Rotate toward player
	var direction_to_player = (player.global_position - global_position).normalized()
	rotation = direction_to_player.angle() + PI / 2
	
	# Check if in dash range
	if distance_to_player <= dash_range:
		start_dash_preparation()

func handle_preparing():
	# Stop moving and rotate toward player
	velocity = Vector2.ZERO
	move_and_slide()
	
	# Keep rotating toward player during preparation
	var direction_to_player = (player.global_position - global_position).normalized()
	rotation = direction_to_player.angle() + PI / 2

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
	has_hit_player = false
	
	# Enable dash attack detection
	dash_attack_area.monitoring = true

func end_dash():
	current_state = DashState.APPROACHING
	velocity = Vector2.ZERO
	
	# Disable dash attack detection
	dash_attack_area.monitoring = false

func _on_dash_timer_timeout():
	start_dash()

func _on_dash_attack_area_body_entered(body):
	if body is Player and current_state == DashState.DASHING and not has_hit_player:
		# Deal damage to player
		body.take_damage(dash_damage)
		has_hit_player = true
		
		# Apply knockback to self
		apply_knockback()

func apply_knockback():
	# Knockback in opposite direction of dash
	var knockback_direction = - dash_direction
	var knockback_position = global_position + (knockback_direction * knockback_distance)
	
	# Create a tween for smooth knockback with easing (fast start, slow end)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", knockback_position, 0.4)
	tween.tween_callback(end_dash)