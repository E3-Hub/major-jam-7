extends Area2D
class_name PlayerBullet

@export var speed: float = 500.0
@export var damage: int = 10
@export var lifetime: float = 5.0

@onready var sprite: Sprite2D = $Sprite2D

var direction: Vector2
var velocity: Vector2
var bullet_color: int
var piercing_through: int

func _ready():
	collision_layer = 4 # Player bullets layer
	collision_mask = 2 # Enemy layer

	piercing_through = GameModifiers.player_piercing_through
	damage = int(damage * GameModifiers.player_damage_modifier)
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

func setup(start_position: Vector2, target_direction: Vector2, color: int):
	global_position = start_position
	direction = target_direction.normalized()
	velocity = direction * speed
	bullet_color = color
	sprite.material.set_shader_parameter("target_color", EnemyColorType.get_color(color))

func _on_body_entered(body):
	if body.has_method("take_damage"):
		var final_damage = damage
		if bullet_color == body.enemy_color:
			final_damage = int(damage * GameModifiers.match_color_damage_modifier)
		body.take_damage(final_damage)

		piercing_through -= 1
		if piercing_through <= 0:
			queue_free()

func _on_lifetime_expired():
	queue_free()
