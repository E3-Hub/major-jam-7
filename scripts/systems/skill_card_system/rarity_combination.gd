class_name RarityCombination

var rarity: float
var rarity_type: String
var combination: Array[String]

func _init(
	c_rarity: float,
	c_rarity_type: String,
	c_combination: Array[String],
	):
	rarity = c_rarity
	rarity_type = c_rarity_type
	combination = c_combination