class_name PatchType

var name: String
var descriptions: Array[String]
var change_templates: Array[String]
var group: String
var min_value: float
var max_value: float

func _init(p_name: String = "", p_descriptions: Array[String] = [], p_change_templates: Array[String] = [], p_group: String = "", p_min_value: float = 0.0, p_max_value: float = 1.0):
	name = p_name
	descriptions = p_descriptions
	change_templates = p_change_templates
	group = p_group
	min_value = p_min_value
	max_value = p_max_value

static var patch_types: Array[PatchType] = [
	PatchType.new(
		"enemy_health_buff",
		["Fixed enemy health being too low", "Enemies were too weak", "Buffed enemy survivability"],
		["Increased enemy health by {value}%", "Enemy HP boosted by {value}%", "Enemies now {value}% more durable"],
		"all_enemy_health",
		0.2,
		0.4,
	),
	PatchType.new(
		"enemy_health_nerf",
		["Enemies were too strong", "Health was overpowered", "Enemy survivability nerfed"],
		["Reduced enemy health by {value}%", "Enemy HP nerfed by {value}%", "Enemies now {value}% less durable"],
		"all_enemy_health",
		-0.2,
		-0.1
	),
	PatchType.new(
		"spawn_rate_increase",
		["Game was too easy", "Players requested more action", "Increased enemy presence"],
		["Increased enemy spawn rate by {value}%", "Enemy spawn rate boosted by {value}%", "Enemies now spawn {value}% faster"],
		"all_enemy_spawn_rate",
		0.1,
		0.2,
	),
	PatchType.new(
		"spawn_rate_decrease",
		["Game was too hard", "Players requested more action", "Increased enemy presence"],
		["Reduced enemy spawn rate by {value}%", "Enemy spawn rate nerfed by {value}%", "Enemies now spawn {value}% slower"],
		"all_enemy_spawn_rate",
		-0.1,
		-0.05
	),
	PatchType.new(
		"player_speed_buff",
		["Improved player movement", "Boosted player speed", "Enhanced mobility for players"],
		["Increased player speed by +{value}%", "Player moves faster +{value}%", "Buffed movement speed (+{value}%)"],
		"player_speed",
		0.1,
		0.2
	),
	PatchType.new(
		"player_speed_nerf",
		["Fixed player speed exploit", "Movement was too fast", "Balanced player mobility"],
		["Reduced player speed by {value}%", "Player movement slowed by {value}%", "Fixed speed exploit ({value}%)"],
		"player_speed",
		-0.2,
		-0.1
	),
	PatchType.new(
		"enemy_speed_buff",
		["Improved enemy AI", "Enhanced enemy behavior", "Enemies too slow"],
		["Increased enemy speed by {value}%", "Enemy movement speed boosted by {value}%", "Enemies now move {value}% faster"],
		"all_enemy_speed",
		0.1,
		0.2
	),
	PatchType.new(
		"enemy_speed_nerf",
		["Enemies were too fast", "Enemy movement speed nerfed", "Combat felt unbalanced"],
		["Reduced enemy speed by {value}%", "Enemy movement speed nerfed by {value}%", "Enemies now move {value}% slower"],
		"all_enemy_speed",
		-0.15,
		-0.1
	),
	PatchType.new(
		"player_damage_buff",
		["Players complained bullets too weak", "Damage was underwhelming", "Combat felt unsatisfying"],
		["Increased player damage by {value}%", "Weapon damage boosted by {value}%", "Player bullets now deal {value}% more damage"],
		"player_damage",
		0.15,
		0.3
	),
	PatchType.new(
		"player_damage_nerf",
		["Players complained bullets too strong", "Damage was overpowered", "Combat felt unbalanced"],
		["Reduced player damage by {value}%", "Weapon damage nerfed by {value}%", "Player bullets now deal {value}% less damage"],
		"player_damage",
		-0.2,
		-0.1
	),
	PatchType.new(
		"enemy_damage_buff",
		["Enemies were too weak", "Enemy damage nerfed", "Combat felt unbalanced"],
		["Increased enemy damage by {value}%", "Enemy weapons boosted by {value}%", "Enemies now deal {value}% more damage"],
		"all_enemy_damage",
		0.1,
		0.2
	),
	PatchType.new(
		"enemy_damage_nerf",
		["Game was too hard", "Enemy damage too high", "Player survivability improved"],
		["Reduced enemy damage by {value}%", "Enemy weapons nerfed by {value}%", "Enemies now deal {value}% less damage"],
		"all_enemy_damage",
		-0.15,
		-0.1
	),
	PatchType.new(
		"bullet_speed_buff",
		["Optimized projectile system", "Performance improvements", "Bullet physics enhanced"],
		["Increased bullet speed by {value}%", "Projectile speed boosted by {value}%", "Bullets now move {value}% faster"],
		"bullet_speed",
		0.1,
		0.3
	),
	PatchType.new(
		"bullet_speed_nerf",
		["Bullets were too fast", "Combat felt unbalanced", "Player movement hindered"],
		["Reduced bullet speed by {value}%", "Projectile speed nerfed by {value}%", "Bullets now move {value}% slower"],
		"bullet_speed",
		-0.2,
		-0.1
	),
	PatchType.new(
		"player_fire_rate_buff",
		["Community requested faster shooting", "Fire rate too slow", "Combat pacing improved"],
		["Reduced shooting cooldown by {value}%", "Fire rate boosted by {value}%", "Shooting speed increased by {value}%"],
		"player_fire_rate",
		0.1,
		0.2
	),
	PatchType.new(
		"player_fire_rate_nerf",
		["Players complained about shooting too fast", "Fire rate was too high", "Combat felt unbalanced"],
		["Reduced shooting cooldown by {value}%", "Fire rate nerfed by {value}%", "Shooting speed slowed by {value}%"],
		"player_fire_rate",
		-0.2,
		-0.1
	),
	PatchType.new(
		"exp_buff",
		["Players requested faster progression", "Leveling was too slow", "Experience was too low"],
		["Increased EXP gain by {value}%", "Experience rewards increased by {value}%", "Leveling speed boosted by {value}%"],
		"experience",
		0.2,
		0.4
	),
	PatchType.new(
		"exp_nerf",
		["Fixed experience exploit", "Leveling too fast", "Progression rebalanced"],
		["Reduced EXP gain by {value}%", "Experience rewards decreased by {value}%", "Leveling slowed by {value}%"],
		"experience",
		-0.2,
		-0.1
	),
	PatchType.new(
		"match_color_damage_buff",
		["Players complained about match color damage", "Match color damage was too low", "Combat felt unbalanced"],
		["Increased match color damage by {value}%", "Match color damage boosted by {value}%", "Match color damage increased by {value}%"],
		"match_color_damage",
		0.2,
		0.4
	),
	PatchType.new(
		"match_color_damage_nerf",
		["Players complained about match color damage", "Match color damage was too high", "Combat felt unbalanced"],
		["Reduced match color damage by {value}%", "Match color damage nerfed by {value}%", "Match color damage decreased by {value}%"],
		"match_color_damage",
		-0.2,
		-0.1
	),
	PatchType.new(
		"patch_power_increase",
		["Players complained about patch power", "Patch power was too low", "Combat felt unbalanced"],
		["Patch now changes more aggressively by {value}%"],
		"patch_power",
		0.2,
		0.4
	),
	PatchType.new(
		"enemy_size_increase",
		["Enemies were too small", "Enemy size was too low", "Combat felt unbalanced"],
		["Increased enemy size by {value}%", "Enemy size boosted by {value}%", "Enemies now {value}% larger"],
		"enemy_size",
		0.1,
		0.2
	),
	PatchType.new(
		"enemy_size_decrease",
		["Enemies were too large", "Enemy size was too high", "Combat felt unbalanced"],
		["Reduced enemy size by {value}%", "Enemy size nerfed by {value}%", "Enemies now {value}% smaller"],
		"enemy_size",
		-0.2,
		-0.1
	),
]