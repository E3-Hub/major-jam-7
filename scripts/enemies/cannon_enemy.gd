extends BaseEnemy
class_name CannonEnemy

@export var spawn_warning_time: float = 3.0
@export var landing_damage: int = 30
@export var landing_radius: float = 40.0
@export var landing_knockback_force: float = 300.0
@export var shoot_range: float = 400.0
@export var shoot_cooldown: float = 4.0
@export var bullet_scene: PackedScene

@onready var warning_circle: Node2D = $LandingArea/WarningCircle
@onready var warning_timer: Timer = $WarningTimer
@onready var shoot_timer: Timer = $ShootTimer
@onready var landing_area: Area2D = $LandingArea

enum CannonState {
	WARNING,
	DROPPING,
	ACTIVE
}

var current_state: CannonState = CannonState.WARNING
var can_shoot: bool = false
var drop_start_scale: Vector2 = Vector2(0.1, 0.1)
var current_pulse_tween: Tween
var base_pulse_duration: float = 1.0 # Slowest pulse duration
var min_pulse_duration: float = 0.1 # Fastest pulse duration

func _ready():
	super._ready()
	
	# Start in warning state
	current_state = CannonState.WARNING
	
	# Set scale for drop effect but keep visible for warning circle
	sprite.scale = drop_start_scale
	
	# Hide only the sprite and collision, keep the entity visible for warning circle
	sprite.visible = false
	$CollisionShape2D.disabled = true
	
	warning_circle.visible = true
	warning_circle.modulate.a = 0.2
	
	# Setup warning timer
	warning_timer.wait_time = spawn_warning_time
	warning_timer.one_shot = true
	warning_timer.timeout.connect(_on_warning_timeout)
	warning_timer.start()
	
	# Setup shoot timer
	shoot_timer.wait_time = shoot_cooldown / (1 + GameModifiers.enemy_fire_rate_modifier)
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
	landing_area.monitoring = false # Only monitor during landing
	
	# Start continuous warning pulse animation
	start_continuous_pulse()

func update_ai(delta):
	if not player:
		return
	
	# Only shoot when active and stationary
	if current_state == CannonState.ACTIVE:
		handle_shooting()

func handle_shooting():
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# Rotate toward player (only sprite, not the whole enemy)
	var direction_to_player = (player.global_position - global_position).normalized()
	sprite.rotation = direction_to_player.angle() + PI / 2
	
	# Shoot if in range and can shoot
	if distance_to_player <= shoot_range and can_shoot and bullet_scene:
		shoot_heavy_bullet()

func shoot_heavy_bullet():
	var direction = (player.global_position - global_position).normalized()
	
	var bullet: EnemyBullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.setup(global_position, direction)
	bullet.scale = Vector2(2.0, 2.0)
	
	can_shoot = false
	shoot_timer.start()

func _on_warning_timeout():
	# Start dropping sequence
	current_state = CannonState.DROPPING
	warning_circle.visible = false
	
	# Kill pulse animation
	if current_pulse_tween:
		current_pulse_tween.kill()
	
	# Show the enemy sprite and enable collision
	sprite.visible = true
	$CollisionShape2D.disabled = false
	
	# Enable landing damage detection
	landing_area.monitoring = true
	
	# Create drop animation
	var tween = create_tween()
	tween.set_parallel(true) # Allow multiple properties to animate simultaneously
	
	# Scale up effect
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.2)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	
	# When drop animation completes, become active and create shockwave
	await tween.finished
	create_shockwave_ripples()
	current_state = CannonState.ACTIVE
	landing_area.monitoring = false # Disable landing damage after drop
	can_shoot = true # Enable shooting when active

func _on_landing_area_body_entered(body):
	if current_state == CannonState.DROPPING and body != self:
		# Deal damage and knockback to other enemies
		body.take_damage(landing_damage)
		apply_knockback_to_target(body)

func _on_shoot_timer_timeout():
	can_shoot = true

func apply_knockback_to_target(target):
	# Calculate knockback direction from cannon to target
	var knockback_direction = (target.global_position - global_position).normalized()
	
	if target is Player:
		target.apply_knockback(knockback_direction * landing_knockback_force)
	elif target is BaseEnemy:
		target.apply_knockback(knockback_direction * landing_knockback_force)

# Override move_towards_player to make cannon stationary
func move_towards_player(delta):
	# Cannon doesn't move - override with empty function
	pass

func start_continuous_pulse():
	if not warning_circle:
		print("Cannot start pulse - warning circle not found")
		return
	
	# Kill existing tween if any
	if current_pulse_tween:
		current_pulse_tween.kill()
		
	# Start continuous pulse with dynamic duration calculation
	update_pulse_continuously()

func update_pulse_continuously():
	if current_state != CannonState.WARNING:
		return
	
	# Calculate current pulse duration based on remaining time
	var time_remaining = warning_timer.time_left
	var time_ratio = time_remaining / spawn_warning_time
	
	# Smooth equation: exponential curve for acceleration
	# pulse_duration = min_duration + (max_duration - min_duration) * time_ratio^3
	# The ^3 creates a smooth curve that starts slow and accelerates rapidly
	var pulse_duration = min_pulse_duration + (base_pulse_duration - min_pulse_duration) * pow(time_ratio, 3.0)
	
	# Create single pulse cycle
	current_pulse_tween = create_tween()
	current_pulse_tween.tween_property(warning_circle, "modulate:a", 0.6, pulse_duration * 0.5)
	current_pulse_tween.tween_property(warning_circle, "modulate:a", 0.2, pulse_duration * 0.5)
	
	# Chain the next pulse cycle
	current_pulse_tween.tween_callback(update_pulse_continuously)

func create_shockwave_ripples():
	# Create multiple expanding ripple rings
	var num_rings = 2
	var ring_delay = 0.1 # Delay between each ring
	
	for i in range(num_rings):
		# Create delayed ring spawn
		await get_tree().create_timer(i * ring_delay).timeout
		if current_state != CannonState.ACTIVE:
			break # Stop if cannon was destroyed
		create_shockwave_ring(i)

func create_shockwave_ring(ring_index: int):
	# Create a ghost ring sprite
	var ring = Sprite2D.new()
	ring.scale = Vector2(1.0, 1.0)
	ring.texture = sprite.texture
	ring.material = sprite.material.duplicate()
	var color = ring.material.get_shader_parameter("target_color")
	var white_color = Color.WHITE.lerp(color, 0.5)
	white_color.a = 0.7
	ring.material.set_shader_parameter("target_color", white_color)
	ring.visible = true
	
	# Add to scene
	add_child(ring)
	
	# Create expanding and fading animation
	var ring_tween = create_tween()
	ring_tween.set_parallel(true)
	
	# Expand the ring
	var shockwave_final_scale = 1.3 + (ring_index * 0.3) # Each ring expands to different size
	ring_tween.tween_property(ring, "scale", Vector2(shockwave_final_scale, shockwave_final_scale), 0.2)
	ring_tween.set_ease(Tween.EASE_OUT)
	ring_tween.set_trans(Tween.TRANS_CUBIC)
	
	# Fade out the ring
	ring_tween.tween_property(ring, "material:shader_parameter/target_color:a", 0.0, 0.2)
	ring_tween.set_ease(Tween.EASE_OUT)
	
	await ring_tween.finished
	if ring and is_instance_valid(ring):
		ring.queue_free()
