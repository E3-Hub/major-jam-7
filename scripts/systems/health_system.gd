extends Node
class_name HealthSystem

signal health_changed(current_health: int, max_health: int)
signal died

@export var max_health: int = 100
var current_health: int

func _ready():
	current_health = int(max_health * (1 + GameModifiers.enemy_health_modifier))
	health_changed.emit(current_health, max_health)

func take_damage(damage: int):
	current_health = max(0, current_health - damage)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		died.emit()

func heal(amount: int):
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)

func is_alive() -> bool:
	return current_health > 0

func get_health_percentage() -> float:
	return float(current_health) / float(max_health)