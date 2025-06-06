extends CharacterBody2D
class_name Player
@onready var health_system: HealthSystem = $HealthSystem
@onready var experience_system: ExperienceSystem = $ExperienceSystem
@onready var shoot_timer: Timer = $ShootTimer
@onready var sprite: Sprite2D = $Sprite2D
@onready var knockback_system: KnockbackSystem = $KnockbackSystem
@onready var ghost_trail_effect: GhostTrailEffect = $GhostTrailEffect

@export var bullet_scene: PackedScene

var dash_speed_speed_ratio: float = 5.0
@export var speed: float = 300.0
@export var dash_speed: float = speed * dash_speed_speed_ratio
@export var dash_duration: float = 0.1
@export var dash_cooldown: float = 1.0
@export var dash_direction = Vector2.ZERO
@export var base_shoot_cooldown: float = 0.2
@export var invincibility_on_damage_duration: float = 1.0 # Duration of invincibility after taking damage
@export var blink_frequency: float = 0.1 # Time between sprite visibility toggles for blinking
var _dash_timer: float = 0.0
var _dash_cooldown_timer: float = 0.0
var _damage_invincibility_timer: float = 0.0 # Timer for invincibility after taking damage
var _blink_toggle_timer: float = 0.0 # Timer to manage blink toggling

var current_color: int = EnemyColorType.RED
var can_shoot: bool = true
var looting: int = 1

signal player_died

func _ready():
	# Connect signals
	health_system.max_health = int(health_system.max_health * GameModifiers.player_health_modifier)
	health_system.died.connect(_on_died)
	# experience_system.level_up.connect(_on_level_up)
	
	# Setup shoot timer
	shoot_timer.wait_time = base_shoot_cooldown
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

	sprite.material.set_shader_parameter("target_color", EnemyColorType.get_color(current_color))

func _physics_process(delta):
	handle_dash(delta)
	knockback_system.handle_knockback(delta)
	handle_movement()
	handle_rotation()
	handle_shooting()
	handle_color_cycling()
	handle_invincibility(delta)

func handle_movement():
	var input_vector = get_input_direction()

	if _dash_timer > 0:
		velocity = dash_direction.normalized() * dash_speed * GameModifiers.player_speed_modifier
	else:
		velocity = input_vector.normalized() * speed * GameModifiers.player_speed_modifier
	
	# Apply knockback on top of normal movement
	velocity += knockback_system.get_knockback_velocity()
	
	move_and_slide()

func handle_dash(delta):
	# Cooldown countdown
	if _dash_cooldown_timer > 0:
		_dash_cooldown_timer -= delta

	# Dash duration countdown
	if _dash_timer > 0:
		_dash_timer -= delta
		if _dash_timer <= 0:
			ghost_trail_effect.stop_effect()
			# If not also invincible from damage, ensure sprite is visible
			if not (_damage_invincibility_timer > 0):
				sprite.visible = true

	# Start dash if key pressed and not on cooldown
	if Input.is_action_just_pressed("dash") and _dash_cooldown_timer <= 0:
		_dash_timer = dash_duration
		_dash_cooldown_timer = dash_cooldown
		ghost_trail_effect.start_effect()
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
	var base_direction = (mouse_pos - global_position).normalized()
	
	var bullet_count = GameModifiers.player_multishot
	
	for i in bullet_count:
		var bullet: PlayerBullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		
		var bullet_direction: Vector2
		
		if bullet_count == 1:
			# Single bullet: just apply base shooting angle modifier
			bullet_direction = base_direction.rotated(deg_to_rad(GameModifiers.shooting_angle))
		else:
			# Multiple bullets: calculate spread
			var total_spread = deg_to_rad(GameModifiers.multishot_shooting_angle)
			var angle_step = total_spread / max(1, bullet_count - 1)
			var start_angle = - total_spread / 2
			var angle_offset = start_angle + (angle_step * i) + deg_to_rad(GameModifiers.shooting_angle)
			bullet_direction = base_direction.rotated(angle_offset)
		
		bullet.setup(global_position, bullet_direction, current_color)
		bullet.damage += GameModifiers.player_damage_additional

	
	can_shoot = false
	shoot_timer.start()

func _on_shoot_timer_timeout():
	can_shoot = true

func take_damage(damage: int):
	# If invincible from dashing or a previous hit, do nothing
	if _dash_timer > 0 or _damage_invincibility_timer > 0:
		return

	health_system.take_damage(damage)
	
	# Trigger screen shake
	var camera = get_viewport().get_camera_2d()
	if camera and camera.has_method("shake_camera"):
		camera.shake_camera()
	
	# Activate invincibility from this damage
	_damage_invincibility_timer = invincibility_on_damage_duration
	# Initialize blink timer to start blinking immediately if not already blinking from dash
	if _dash_timer <= 0:
		_blink_toggle_timer = blink_frequency
		# sprite.visible = false # Optional: Set initial blink state, handle_invincibility will cover it

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

func apply_knockback(force: Vector2):
	knockback_system.apply_knockback(force)

func handle_invincibility(delta: float):
	var is_currently_invincible: bool = _dash_timer > 0 or (_damage_invincibility_timer > 0)

	if _damage_invincibility_timer > 0:
		_damage_invincibility_timer -= delta
		if _damage_invincibility_timer <= 0 and _dash_timer <= 0: # Damage invincibility wore off, and not dashing
			sprite.visible = true # Ensure sprite is visible

	if is_currently_invincible:
		_blink_toggle_timer -= delta
		if _blink_toggle_timer <= 0:
			sprite.visible = not sprite.visible
			_blink_toggle_timer = blink_frequency
	else:
		# Ensure sprite is always visible when not invincible for any reason
		if sprite.visible == false: # Only set if it was left in a hidden state
			sprite.visible = true
		_blink_toggle_timer = 0 # Reset blink timer

func reset_all_player_states():
	dash_speed_speed_ratio = 5.0
	speed = 300.0
	dash_speed = speed * dash_speed_speed_ratio
	dash_duration = 0.1
	dash_cooldown = 1.0
	dash_direction = Vector2.ZERO
	base_shoot_cooldown = 0.2
	invincibility_on_damage_duration = 1.0 # Duration of invincibility after taking damage
	blink_frequency = 0.1 # Time between sprite visibility toggles for blinking
	_dash_timer = 0.0
	_dash_cooldown_timer = 0.0
	_damage_invincibility_timer = 0.0 # Timer for invincibility after taking damage
	_blink_toggle_timer = 0.0 # Timer to manage blink toggling
	current_color = EnemyColorType.RED
	can_shoot = true
	looting = 1
	health_system.max_health = 100
	experience_system.additional_gain_experience = 0
