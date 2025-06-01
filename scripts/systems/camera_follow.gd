extends Camera2D
class_name CameraFollow

@export var follow_speed: float = 5.0
@export var follow_offset: Vector2 = Vector2.ZERO

var target: Node2D

func _ready():
	# Find the player
	target = get_tree().get_first_node_in_group("player")

func _process(delta):
	if target:
		var target_position = target.global_position + follow_offset
		global_position = global_position.lerp(target_position, follow_speed * delta) 