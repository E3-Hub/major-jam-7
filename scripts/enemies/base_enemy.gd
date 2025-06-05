extends CharacterBody2D
class_name BaseEnemy

@export var speed: float = 100.0
@export var exp_value: int = 5

@onready var health_system: HealthSystem = $HealthSystem
@onready var sprite: Sprite2D = $Sprite2D
@onready var knockback_system: KnockbackSystem = $KnockbackSystem

var player: Player
var exp_orb_scene: PackedScene
var enemy_color: int

signal enemy_died(enemy: BaseEnemy)

func _ready():
	exp_value = int(exp_value * GameModifiers.experience_modifier)
	speed *= GameModifiers.enemy_speed_modifier
	health_system.max_health = int(health_system.max_health * GameModifiers.enemy_health_modifier)
	health_system.current_health = health_system.max_health

	# Connect health system
	health_system.died.connect(_on_died)
	
	# Find player
	player = get_tree().get_first_node_in_group("player")
	
	# Add to enemies group for patch system
	add_to_group("enemies")
	
	# Try to load exp orb scene
	if ResourceLoader.exists("res://scenes/world/exp_orb.tscn"):
		exp_orb_scene = load("res://scenes/world/exp_orb.tscn")

func setup(color_type: int):
	enemy_color = color_type
	sprite.material.set_shader_parameter("target_color", EnemyColorType.get_color(enemy_color))

func _physics_process(delta):
	if player and health_system.is_alive():
		knockback_system.handle_knockback(delta)
		update_ai(delta)

	velocity = knockback_system.get_knockback_velocity()
	move_and_slide()

func update_ai(delta):
	# Override in derived classes
	pass

func move_towards_player(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		move_and_slide()

func take_damage(damage: int):
	health_system.take_damage(damage)
	

func _on_died():
	drop_experience()
	enemy_died.emit(self)
	queue_free()

func drop_experience():
	var exp_orb: ExpOrb = exp_orb_scene.instantiate()
	get_tree().current_scene.add_child(exp_orb)
	exp_orb.global_position = global_position
	exp_orb.setup(exp_value)

func apply_knockback(force: Vector2):
	knockback_system.apply_knockback(force)
