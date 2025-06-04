extends Node
class_name EffectLibrary

var player: Player


func _ready():
	player = get_tree().get_first_node_in_group("player")

func apply_card_effect(effect_name: String, value: int):
	match effect_name:
		"increase_looting":
			player.looting += value
		"increase_health":
			player.health_system.heal(value)

# static func apply_looting_plus_one(game_manager: GameManager) -> void:
#     game_manager.player.looting += 1
#     print("player looting:",game_manager.player.looting)




