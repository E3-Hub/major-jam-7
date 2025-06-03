extends CharacterBody2D
class_name BaseEnemy

@export var speed: float = 100.0
@export var exp_value: int = 10
@export var bullet_scene: PackedScene

@onready var health_system: HealthSystem = $HealthSystem

var player: Player
var exp_orb_scene: PackedScene

signal enemy_died(enemy: BaseEnemy)

func _ready():
	# Set up collision layers
	collision_layer = 2 # Enemy layer
	collision_mask = 1 # Player layer
	
	# Connect health system
	health_system.died.connect(_on_died)
	
	# Find player
	player = get_tree().get_first_node_in_group("player")
	
	# Add to enemies group for patch system
	add_to_group("enemies")
	
	# Try to load exp orb scene
	if ResourceLoader.exists("res://scenes/world/exp_orb.tscn"):
		exp_orb_scene = load("res://scenes/world/exp_orb.tscn")

func _physics_process(delta):
	if player and health_system.is_alive():
		update_ai(delta)

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

# Patch system modifier methods
func apply_health_modifier(multiplier: float):
	var old_max = health_system.max_health
	var health_percentage = health_system.get_health_percentage()
	
	health_system.max_health = int(old_max * multiplier)
	health_system.current_health = int(health_system.max_health * health_percentage)
	health_system.health_changed.emit(health_system.current_health, health_system.max_health)

func apply_speed_modifier(multiplier: float):
	speed *= multiplier

func apply_exp_modifier(multiplier: float):
	exp_value = int(exp_value * multiplier)
