extends Node
class_name CardSystem

@onready var effect_library: EffectLibrary = $EffectLibrary


var player: Player
var ui_manager: UIManager
var current_choices: Array[Card] = []
var card_number: int = 2

func _ready():
	ui_manager = get_parent().get_node("UIManager")
	player = get_tree().get_first_node_in_group("player")
	player.experience_system.level_up.connect(generate_random_card_choices)
	
func generate_random_card_choices(new_level: int):
	current_choices.clear()
	var all_cards: Array[Card] = CardLibrary.all_cards
	current_choices = pick_n_random_cards(all_cards, card_number)
	print("now looting",player.looting)
	print("card system trigger", new_level, current_choices)
	ui_manager.show_card_choices(current_choices, _on_card_selected)


func _on_card_selected(card: Card):
	# apply all effects
	var status_text = ""
	for effect_name in card.effects:
		var value = card.effects[effect_name]
		var bonus_value = randi() % 3
		status_text += "%s [+%s]+%s\n" % [effect_name, value, bonus_value]
		value += bonus_value
		effect_library.apply_card_effect(effect_name, value)
	ui_manager.show_effect_panel(card.description, status_text)


func pick_n_random_cards(cards: Array[Card], count: int) -> Array[Card]:
	var result: Array[Card] = []
	var pool: Array[Card] = cards.duplicate()
	
	while result.size() < count and pool.size() > 0:
		var card = pool.pick_random()
		result.append(card)
		pool.erase(card)
	
	return result

func get_n_weighted_random_cards(cards: Array, n: int) -> Array:
	var selected: Array = []
	var remaining_cards = cards.duplicate() # To avoid modifying the original array
	remaining_cards.shuffle()

	n = min(n, remaining_cards.size()) # Avoid requesting more than available

	for i in n:
		var total_weight = 0.0
		for card in remaining_cards:
			total_weight += card.rarity

		var pick = randf() * total_weight
		var current = 0.0

		for card in remaining_cards:
			current += card.rarity
			if pick <= current:
				selected.append(card)
				remaining_cards.erase(card)
				break

	return selected
