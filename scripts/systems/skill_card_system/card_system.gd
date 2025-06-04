extends Node
class_name CardSystem

# @onready var experience_system: ExperienceSystem = get_node("../Player/ExperienceSystem")


var game_manager: GameManager
var player: Player
var current_choices: Array[Card] = []
var card_number: int = 1

func _ready():
	game_manager = get_tree().get_first_node_in_group("game_manager")
	player = get_tree().get_first_node_in_group("player")
	player.experience_system.level_up.connect(generate_random_card_choices)
	
func generate_random_card_choices(new_level: int):
	current_choices.clear()
	var all_cards: Array[Card] = CardLibrary.all_cards
	current_choices = pick_n_random_cards(all_cards, card_number)
	print("now looting",player.looting)
	print("card system trigger", new_level, current_choices)
	game_manager.ui_manager.show_card_choices(current_choices, _on_card_selected)


func _on_card_selected(card: Card):
	card.apply_effect.call(game_manager)


func pick_n_random_cards(cards: Array[Card], count: int) -> Array[Card]:
	var result: Array[Card] = []
	var pool: Array[Card] = cards.duplicate()
	
	while result.size() < count and pool.size() > 0:
		var card = pool.pick_random()
		result.append(card)
		pool.erase(card)
	
	return result
