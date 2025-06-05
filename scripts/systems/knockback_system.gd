extends Node
class_name KnockbackSystem

@export var knockback_decay: float = 5.0 # How fast knockback decays

var knockback_velocity: Vector2 = Vector2.ZERO

func _ready():
	# Set process mode to always so it works even when paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func handle_knockback(delta: float):
	# Gradually reduce knockback velocity
	if knockback_velocity.length() > 0:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * knockback_velocity.length() * delta)

func apply_knockback(force: Vector2):
	knockback_velocity += force

func get_knockback_velocity() -> Vector2:
	return knockback_velocity

func clear_knockback():
	knockback_velocity = Vector2.ZERO