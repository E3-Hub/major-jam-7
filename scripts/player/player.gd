extends CharacterBody2D
class_name Player

@export var speed: float = 300.0
@export var bullet_scene: PackedScene
@export var shoot_cooldown: float = 0.2

@onready var health_system: HealthSystem = $HealthSystem
@onready var experience_system: ExperienceSystem = $ExperienceSystem
@onready var shoot_timer: Timer = $ShootTimer

var can_shoot: bool = true

signal player_died

func _ready():
	# Set up collision layers
	collision_layer = 1  # Player layer
	collision_mask = 2   # Enemy layer
	
	# Connect signals
	health_system.died.connect(_on_died)
	experience_system.level_up.connect(_on_level_up)
	
	# Setup shoot timer
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(delta):
	handle_movement()
	handle_shooting()

func handle_movement():
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	
	velocity = input_vector.normalized() * speed
	move_and_slide()

func handle_shooting():
	if Input.is_action_pressed("shoot") and can_shoot and bullet_scene:
		shoot()

func shoot():
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.setup(global_position, direction, 25, 600.0, true)
	
	can_shoot = false
	shoot_timer.start()

func _on_shoot_timer_timeout():
	can_shoot = true

func take_damage(damage: int):
	health_system.take_damage(damage)

func collect_experience(amount: int):
	experience_system.add_experience(amount)

func _on_died():
	player_died.emit()

func _on_level_up(new_level: int):
	print("Player leveled up to level ", new_level)
	# Here you can add level up effects like increased stats 