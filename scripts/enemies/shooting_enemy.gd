extends BaseEnemy
class_name ShootingEnemy

@export var shoot_range: float = 300.0
@export var shoot_cooldown: float = 2.0
@export var stop_distance: float = 150.0

@onready var shoot_timer: Timer = $ShootTimer

var can_shoot: bool = true

func _ready():
	super._ready()
	
	# Setup shoot timer
	shoot_timer.wait_time = shoot_cooldown / GameModifiers.enemy_fire_rate_modifier
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func update_ai(delta):
	if not player:
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# Rotate toward player
	var direction_to_player = (player.global_position - global_position).normalized()
	rotation = direction_to_player.angle() + PI / 2
	
	# Move towards player if too far, but stop at a certain distance
	if distance_to_player > stop_distance:
		move_towards_player(delta)
	
	# Shoot if in range and can shoot
	if distance_to_player <= shoot_range and can_shoot and bullet_scene:
		shoot_at_player()

func shoot_at_player():
	var direction = (player.global_position - global_position).normalized()
	
	var bullet: EnemyBullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.setup(global_position, direction)
	
	can_shoot = false
	shoot_timer.start()

func _on_shoot_timer_timeout():
	can_shoot = true
