extends Area2D
class_name EnemyBullet

@export var speed: float = 300.0
@export var damage: int = 10
@export var lifetime: float = 5.0

var direction: Vector2
var velocity: Vector2

func _ready():
	collision_layer = 8 # Enemy bullets layer
	collision_mask = 1 # Player layer
	scale *= GameModifiers.enemy_size_modifier

	damage = int(damage * GameModifiers.enemy_damage_modifier)
	speed *= GameModifiers.bullet_speed_modifier
	if GameModifiers.bullet_chaos_mode:
		speed *= randf_range(0.5, 1.5)
	
	# Connect collision signal
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
	queue_free()
