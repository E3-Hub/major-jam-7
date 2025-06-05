extends Node
class_name CardSystem

@onready var effect_library: EffectLibrary = $EffectLibrary


var player: Player
var ui_manager: UIManager
var current_choices: Array[Card] = []
var card_number: int = 4

func _ready():
	ui_manager = get_parent().get_node("UIManager")
	player = get_tree().get_first_node_in_group("player")
	player.experience_system.level_up.connect(generate_random_card_choices)
	
func generate_random_card_choices(new_level: int):
	current_choices.clear()
	# var all_cards: Array[Card] = CardLibrary.all_cards
	# current_choices = pick_n_random_cards(all_cards, card_number)

	var all_rarity_combination: Array[RarityCombination] = CardLibrary.all_rarity_combination
	current_choices = get_n_weighted_random_card(all_rarity_combination, card_number)
	print("now looting", player.looting)
	print("card system trigger", new_level, current_choices)
	ui_manager.show_card_choices(current_choices, _on_card_selected)


func _on_card_selected(card: Card):
	# apply all effects
	var status_text = ""
	for effect_name in card.effects:
		var value = card.effects[effect_name]
		var bonus_value = randi() % 3
		var show_effect_name = effect_name
		var show_unit = ""
		if "_percent" in effect_name:
			show_effect_name = show_effect_name.replace("_percent", "")
			show_unit = "%"
		var show_symbol = "+"
		if "decrease_" in effect_name:
			show_effect_name =show_effect_name.replace("decrease_", "")
			show_symbol = "-"
		if "increase_" in effect_name:
			show_effect_name =show_effect_name.replace("increase_", "")
		status_text += "%s %s[%s%s]+%s%s\n" % [effect_name, show_symbol, value, show_unit, bonus_value, show_unit]
		value += bonus_value
		effect_library.apply_card_effect(effect_name, value)
	ui_manager.show_effect_panel(card.description, status_text)


# func pick_n_random_cards(cards: Array[Card], count: int) -> Array[Card]:
# 	var result: Array[Card] = []
# 	var pool: Array[Card] = cards.duplicate()
	
# 	while result.size() < count and pool.size() > 0:
# 		var card = pool.pick_random()
# 		result.append(card)
# 		pool.erase(card)
	
# 	return result

func get_n_weighted_random_card(all_rarity_combination: Array[RarityCombination], count: int) -> Array[Card]:
	var selected_cards: Array[Card] = []
	var sorted_rarity_combination = all_rarity_combination.duplicate()
	var rarity_from_looting = ((player.looting - 1) * (1 + GameModifiers.looting_modifier)) * CardLibrary.looting_to_rarity_factor
	print("rarity_from_looting", rarity_from_looting)

	for i in range(count):
		var current = 0.0
		var pick = randf() * CardLibrary.total_weight_rarity
		var all_stats = CardLibrary.stats.duplicate()
		for rarity_combination in sorted_rarity_combination:
			var rarity_values = rarity_combination.rarity
			print("rarity_values", rarity_values)
			rarity_values = rarity_values + rarity_from_looting if rarity_values < CardLibrary.invert_rarity_line else rarity_values - rarity_from_looting
			print("rarity_shift", rarity_values)
			current += rarity_values

			if pick <= current:
				print(pick, "<=", current, rarity_combination.rarity_type)
				var selected_card_title = ""
				var selected_rarity = rarity_combination.rarity
				var selected_rarity_type = rarity_combination.rarity_type
				var random_descriptions: Array[String] = []
				var selected_effects: Dictionary[String, int] ={}
				for increase_or_decrease in rarity_combination.combination:
					var random_values_type = CardLibrary.values_type[randi() % CardLibrary.values_type.size()]
					var index = randi() % all_stats.size()
					var random_stats = all_stats[index]
					all_stats.remove_at(index)

					var values_type_display = "" if random_values_type == "amount" else "_percent"
					var show_unit ="" if random_values_type == "amount" else "%"
					var show_stats_type = random_stats + values_type_display
					var show_symbol = ""
					var values_range = CardLibrary.card_values_range[random_stats][random_values_type+"_range"]
					var value: int
					var max_val: float
					var min_val: float
					var step: float = (values_range[1]-values_range[0])/all_rarity_combination.size()
					if increase_or_decrease == "increase":
						show_symbol = "+"
						max_val = values_range[0] + step * CardLibrary.values_increase_boundary_ratio_factor[selected_rarity_type]
						min_val = max_val - step
					elif increase_or_decrease == "decrease":
						show_symbol = "-"
						max_val = values_range[0] + step * CardLibrary.values_decrease_boundary_ratio_factor[selected_rarity_type]
						min_val = max_val - step
					value = randi() % int(floor(max_val) - ceil(min_val) + 1) + int(ceil(min_val))
					selected_card_title += "%s %s(%s)%s\n" % [random_stats, show_symbol, value, show_unit]
					var descriptions_list: Array = CardLibrary.descriptions[increase_or_decrease + "_" + random_stats]
					random_descriptions.append(descriptions_list[randi() % descriptions_list.size()])
					selected_effects[increase_or_decrease + "_" + show_stats_type ] = value
				
				var selected_card: Card = Card.new(
					selected_rarity,
					selected_rarity_type,
					selected_card_title,
					random_descriptions[randi() % 2],
					selected_effects,
				)
				selected_cards.append(selected_card)
				break

	return selected_cards
