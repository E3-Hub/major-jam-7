extends Area2D
class_name ExpOrb

@export var exp_value: int = 10
@export var move_speed: float = 400.0

var player: Player
var is_being_collected: bool = false

func _ready():
	# Set up collision layers
	collision_layer = 16 # Exp orb layer
	collision_mask = 1 # Player layer
	
	# Connect signals
	body_entered.connect(_on_body_entered)
	
	# Find player
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player and is_being_collected:
		# Move towards player
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * move_speed * delta
		
		# Check if close enough to collect
		if global_position.distance_to(player.global_position) < 20.0:
			collect()

func setup(value: int):
	exp_value = value

func _on_body_entered(body):
	if body is Player:
		is_being_collected = true

func collect():
	if player:
		player.collect_experience(exp_value)
	queue_free()
