class_name Card

var rarity: float
var title: String
var description: String
var effects: Dictionary[String, int]
# var icon: Texture2D

func _init(
	c_rarity: float,
	c_title: String,
	c_description: String,
	c_effects: Dictionary[String, int],
	# c_icon: Texture2D,
	):
	rarity = c_rarity
	title = c_title
	description = c_description
	effects = c_effects
	# icon = c_icon