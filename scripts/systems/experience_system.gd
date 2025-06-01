extends Node
class_name ExperienceSystem

signal level_up(new_level: int)
signal experience_gained(current_exp: int, exp_to_next_level: int)

var current_level: int = 1
var current_experience: int = 0
var experience_to_next_level: int = 100

func _ready():
	experience_gained.emit(current_experience, experience_to_next_level)

func add_experience(amount: int):
	current_experience += amount
	experience_gained.emit(current_experience, experience_to_next_level)
	
	while current_experience >= experience_to_next_level:
		level_up_player()

func level_up_player():
	current_experience -= experience_to_next_level
	current_level += 1
	experience_to_next_level = int(experience_to_next_level * 1.2)  # Increase exp requirement by 20%
	
	level_up.emit(current_level)
	experience_gained.emit(current_experience, experience_to_next_level)

func get_level() -> int:
	return current_level

func get_experience_percentage() -> float:
	return float(current_experience) / float(experience_to_next_level) 