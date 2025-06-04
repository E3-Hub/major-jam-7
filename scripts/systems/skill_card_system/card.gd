class_name Card

var rarity: float
var title: String
var description: String
var apply_effect: Callable
var icon: Texture2D

func _init(
	c_rarity: float,
	c_title: String,
	c_description: String,
	c_apply_effect: Callable,
	# c_icon: Texture2D,
	):
	rarity = c_rarity
	title = c_title
	description = c_description
	apply_effect = c_apply_effect
	# icon = c_icon
