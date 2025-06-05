class_name GhostTrailEffect
extends Node2D

@export var ghost_interval: float = 0.05
@export var ghost_fade_time: float = 0.2
@export var ghost_scale: float = 0.9
@export var sprite: Sprite2D

var color: Color
var _ghost_timer: Timer

func _ready():
	_ghost_timer = Timer.new()
	_ghost_timer.wait_time = ghost_interval
	_ghost_timer.timeout.connect(_on_ghost_timer_timeout)
	add_child(_ghost_timer)

func start_effect():
	_ghost_timer.start()

func stop_effect():
	_ghost_timer.stop()

func create_ghost():
	var ghost = Sprite2D.new()
	ghost.texture = sprite.texture
	ghost.material = sprite.material.duplicate()
	ghost.material.set_shader_parameter("target_color", color)
	ghost.global_position = sprite.global_position
	ghost.rotation = sprite.rotation
	ghost.scale = sprite.scale * ghost_scale
	ghost.z_index = sprite.z_index - 1

	get_tree().current_scene.add_child(ghost)

	var tween = create_tween()
	tween.tween_property(ghost.material, "shader_parameter/target_color", Color(color.r, color.g, color.b, 0.0), ghost_fade_time)
	await tween.finished
	if ghost and is_instance_valid(ghost):
		ghost.queue_free()

func _on_ghost_timer_timeout():
	create_ghost()