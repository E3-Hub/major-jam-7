extends Node
class_name PatchSystem

@export var min_patch_interval: float = 20
@export var max_patch_interval: float = 30

@onready var patch_timer: Timer = $PatchTimer

var game_manager: GameManager
var enemy_spawner: EnemySpawner
var player: Player
var patch_count: int = 0

const patch_titles = [
	"Hotfix v{major}.{minor}.{patch}",
	"Balance Update v{major}.{minor}.{patch}",
	"Emergency Patch v{major}.{minor}.{patch}",
	"Content Update v{major}.{minor}.{patch}",
	"Performance Update v{major}.{minor}.{patch}",
	"Community Request v{major}.{minor}.{patch}",
	"Bugfix v{major}.{minor}.{patch}",
	"Experimental Patch v{major}.{minor}.{patch}",
	"Developer Response v{major}.{minor}.{patch}",
	"Critical Update v{major}.{minor}.{patch}"
]

const funny_additions = [
	"Good luck!",
	"This might break everything",
	"We're not sorry",
	"Deal with it",
	"Working as intended",
	"Oops",
	"You asked for this",
	"Blame the community",
	"RNG gods have spoken",
	"Perfectly balanced"
]

var version_major: int = 0
var version_minor: int = 0
var version_patch: int = 0

func _ready():
	# Find game components
	game_manager = get_tree().get_first_node_in_group("game_manager")
	enemy_spawner = get_tree().get_first_node_in_group("enemy_spawner")
	player = get_tree().get_first_node_in_group("player")
	
	# Setup patch timer
	patch_timer.wait_time = randf_range(min_patch_interval, max_patch_interval)
	patch_timer.one_shot = true
	patch_timer.timeout.connect(_on_patch_timer_timeout)
	patch_timer.start()

func _on_patch_timer_timeout():
	apply_random_patch()
	
	# Schedule next patch
	patch_timer.wait_time = randf_range(min_patch_interval, max_patch_interval)
	patch_timer.start()

func generate_random_patches() -> Array[PatchData]:
	var patches_selected: Array[PatchData] = []
	var patch_types_left: Array[PatchType] = PatchType.patch_types
	for i in 3:
		var patch_type: PatchType = patch_types_left[randi() % patch_types_left.size()]
		patch_types_left = patch_types_left.filter(func(p): return p.group != patch_type.group)
	
		var value = randf_range(patch_type.min_value, patch_type.max_value)
		var description = patch_type.descriptions[randi() % patch_type.descriptions.size()]
		var change_template = patch_type.change_templates[randi() % patch_type.change_templates.size()]
		var change_text = change_template.format({"value": int(abs(value * 100))})
	
		var text = description + "\n• " + change_text
		if randf() < 0.3: # 30% chance
			text += "\n• " + funny_additions[randi() % funny_additions.size()]

		patches_selected.append(PatchData.new(text, patch_type.group, value))
	
	return patches_selected

func increment_version():
	version_patch += 1
	if version_patch > 9:
		version_patch = 0
		version_minor += 1
		if version_minor > 9:
			version_minor = 0
			version_major += 1

func apply_random_patch():
	var patches: Array[PatchData] = generate_random_patches()
	var changes_text = ""

	patch_count += 1
	for patch in patches:
		changes_text += patch.text + "\n"
		apply_patch_effect(patch)

	increment_version()
	var title_template = patch_titles[randi() % patch_titles.size()]
	var title = title_template.format({
		"major": version_major,
		"minor": version_minor,
		"patch": version_patch
	})
	
	game_manager.ui_manager.show_patch_notes(title, changes_text)

func apply_patch_effect(patch: PatchData):
	match patch.group:
		"all_enemy_health":
			GameModifiers.enemy_health_modifier += patch.value
		"all_enemy_spawn_rate":
			GameModifiers.enemy_spawn_rate_modifier += patch.value
		"player_speed":
			GameModifiers.player_speed_modifier += patch.value
		"all_enemy_speed":
			GameModifiers.enemy_speed_modifier += patch.value
		"player_damage":
			GameModifiers.player_damage_modifier += patch.value
		"all_enemy_damage":
			GameModifiers.enemy_damage_modifier += patch.value
		"bullet_speed":
			GameModifiers.bullet_speed_modifier += patch.value
		"player_fire_rate":
			GameModifiers.player_fire_rate_modifier += patch.value
			player.shoot_timer.wait_time = player.base_shoot_cooldown / (1 + GameModifiers.player_fire_rate_modifier)
		"experience":
			GameModifiers.experience_modifier += patch.value