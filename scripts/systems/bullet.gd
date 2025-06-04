extends Area2D
class_name Bullet

@export var speed: float = 500.0
@export var damage: int = 10
@export var lifetime: float = 5.0
@export var is_player_bullet: bool = true

var direction: Vector2
var velocity: Vector2

func _ready():
	# Set up collision layers
	if is_player_bullet:
		collision_layer = 4 # Player bullets layer
		collision_mask = 2 # Enemy layer
	else:
		collision_layer = 8 # Enemy bullets layer
		collision_mask = 1 # Player layer

	damage = int(damage * (1 + (GameModifiers.enemy_damage_modifier if is_player_bullet else GameModifiers.player_damage_modifier)))
	speed *= (1 + GameModifiers.bullet_speed_modifier)
	if GameModifiers.bullet_chaos_mode:
		speed *= randf_range(0.5, 1.5)
	
	# Connect collision
	body_entered.connect(_on_body_entered)
	
	# Auto-destroy after lifetime
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(_on_lifetime_expired)
	add_child(timer)
	timer.start()

func _physics_process(delta):
	# Move the bullet
	global_position += velocity * delta

func setup(start_position: Vector2, target_direction: Vector2):
	global_position = start_position
	direction = target_direction.normalized()
	velocity = direction * speed

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

func _on_lifetime_expired():
	print("destroy bullet")
	queue_free()
