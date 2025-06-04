extends CharacterBody2D
class_name Player

@export var speed: float = 300.0
@export var dash_speed: float
@export var is_dashing: bool = false
@export var dash_duration: float = 0.2 # seconds
@export var dash_timer: float = 0.0
@export var dash_cooldown: float = 1.0
@export var dash_cooldown_timer: float = 0.0
@export var dash_direction = Vector2.ZERO
@export var bullet_scene: PackedScene
@export var base_shoot_cooldown: float = 0.2

@export var player_red_sprite: Texture2D
@export var player_green_sprite: Texture2D
@export var player_blue_sprite: Texture2D

@onready var health_system: HealthSystem = $HealthSystem
@onready var experience_system: ExperienceSystem = $ExperienceSystem
@onready var shoot_timer: Timer = $ShootTimer
@onready var sprite: Sprite2D = $Sprite2D

var current_color: int = EnemyColorType.RED
var can_shoot: bool = true

signal player_died

func _ready():
	# Set up collision layers
	collision_layer = 1 # Player layer
	collision_mask = 2 # Enemy layer
	
	# Connect signals
	health_system.died.connect(_on_died)
	experience_system.level_up.connect(_on_level_up)
	
	# Setup shoot timer
	shoot_timer.wait_time = base_shoot_cooldown
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

	sprite.material.set_shader_parameter("target_color", EnemyColorType.get_color(current_color))

func _physics_process(delta):
	handle_dash(delta)
	handle_movement()
	handle_rotation()
	handle_shooting()
	handle_color_cycling()

func handle_movement():
	dash_speed = speed * 3
	var input_vector = get_input_direction()

	if is_dashing:
		velocity = dash_direction.normalized() * dash_speed * (1 + GameModifiers.player_speed_modifier)
	else:
		velocity = input_vector.normalized() * speed * (1 + GameModifiers.player_speed_modifier)

	move_and_slide()

func handle_dash(delta):
	# Cooldown countdown
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	# Dash duration countdown
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# Start dash if key pressed and not on cooldown
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and not is_dashing:
		is_dashing = true
		dash_timer = dash_duration
		dash_cooldown_timer = dash_cooldown
		# Dash in the current input direction
		dash_direction = get_input_direction()

func get_input_direction() -> Vector2:
	var dir = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		dir.x -= 1
	if Input.is_action_pressed("move_right"):
		dir.x += 1
	if Input.is_action_pressed("move_up"):
		dir.y -= 1
	if Input.is_action_pressed("move_down"):
		dir.y += 1
	return dir

func handle_rotation():
	var mouse_pos = get_global_mouse_position()
	var direction_to_mouse = (mouse_pos - global_position).normalized()
	rotation = direction_to_mouse.angle() + PI / 2

func handle_shooting():
	if Input.is_action_pressed("shoot") and can_shoot and bullet_scene:
		shoot()

func shoot():
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	var bullet: PlayerBullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.setup(global_position, direction, current_color)
	
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

func handle_color_cycling():
	if Input.is_action_just_pressed("cycle_color_next"):
		current_color = (current_color + 1) % 3
		sprite.material.set_shader_parameter("target_color", EnemyColorType.get_color(current_color))
	elif Input.is_action_just_pressed("cycle_color_prev"):
		current_color = (current_color - 1 + 3) % 3
		sprite.material.set_shader_parameter("target_color", EnemyColorType.get_color(current_color))
