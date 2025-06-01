extends RigidBody2D
class_name Bullet

@export var speed: float = 500.0
@export var damage: int = 10
@export var lifetime: float = 5.0
@export var is_player_bullet: bool = true

var direction: Vector2

func _ready():
	# Set up collision layers
	if is_player_bullet:
		collision_layer = 4 # Player bullets layer
		collision_mask = 2 # Enemy layer
	else:
		collision_layer = 8 # Enemy bullets layer
		collision_mask = 1 # Player layer
	
	# Set velocity
	linear_velocity = direction * speed
	
	# Auto-destroy after lifetime
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(_on_lifetime_expired)
	add_child(timer)
	timer.start()

func setup(start_position: Vector2, target_direction: Vector2, bullet_damage: int = 10, bullet_speed: float = 500.0, player_bullet: bool = true):
	global_position = start_position
	direction = target_direction.normalized()
	damage = bullet_damage
	speed = bullet_speed
	is_player_bullet = player_bullet

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

func _on_lifetime_expired():
	queue_free()
