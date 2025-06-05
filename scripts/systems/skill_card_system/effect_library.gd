extends Node
class_name EffectLibrary

var player: Player


func _ready():
	player = get_tree().get_first_node_in_group("player")

func apply_card_effect(effect_name: String, value: int):
	match effect_name:
		"increase_looting":
			player.looting += value
		"increase_looting_percent":
			pass


		"increase_health":
			player.health_system.heal(value)
		"increase_health_percent":
			pass


		"increase_movement_speed":
			pass
		"increase_movement_speed_percent":
			pass


		"increase_damage":
			pass
		"increase_damage_percent":
			pass


		"increase_looting":
			pass
		"increase_looting_percent":
			pass


		"increase_health":
			pass
		"increase_health_percent":
			pass


		"increase_max_health":
			pass
		"increase_max_health_percent":
			pass


		"increase_EXP_gain":
			pass
		"increase_EXP_gain_percent":
			pass


		"increase_fire_rate_rpm":
			pass
		"increase_fire_rate_rpm_percent":
			pass

		_:
			print("Unknown effect name: ", effect_name, value)
		

# static func apply_looting_plus_one(game_manager: GameManager) -> void:
#     game_manager.player.looting += 1
#     print("player looting:",game_manager.player.looting)
