extends Camera2D
class_name CameraFollow

@export var follow_speed: float = 5.0
@export var follow_offset: Vector2 = Vector2.ZERO
@export var shake_intensity: float = 150.0
@export var shake_duration: float = 0.3
@export var shake_fade_speed: float = 5.0

@onready var target: Node2D = get_tree().get_first_node_in_group("player")
var shake_timer: float = 0.0
var shake_amount: float = 0.0

func _process(delta):
	if target:
		var target_position = target.global_position + follow_offset
		
		# Handle screen shake
		var shake_offset = Vector2.ZERO
		if shake_timer > 0:
			shake_timer -= delta
			shake_amount = lerp(shake_amount, 0.0, shake_fade_speed * delta)
			
			# Generate random shake offset
			shake_offset = Vector2(
				randf_range(-shake_amount, shake_amount),
				randf_range(-shake_amount, shake_amount)
			)
		
		global_position = global_position.lerp(target_position + shake_offset, follow_speed * delta)

func shake_camera(intensity: float = 0.0, duration: float = 0.0):
	var shake_strength = intensity if intensity > 0 else shake_intensity
	var shake_time = duration if duration > 0 else shake_duration
	
	shake_timer = shake_time
	shake_amount = shake_strength