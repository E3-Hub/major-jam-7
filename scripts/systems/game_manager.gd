extends Node
class_name GameManager

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var ui_manager: UIManager = $UIManager
@onready var patch_system: PatchSystem = $PatchSystem

var game_time: float = 0.0
var is_game_over: bool = false

signal game_over

func _ready():
	player.player_died.connect(_on_player_died)
	player.health_system.health_changed.connect(_on_player_health_changed)
	player.experience_system.experience_gained.connect(_on_player_exp_changed)
	player.experience_system.level_up.connect(_on_player_level_up)

func _process(delta):
	if not is_game_over:
		game_time += delta
		ui_manager.update_time(game_time)

func _on_player_died():
	is_game_over = true
	game_over.emit()
	ui_manager.show_game_over(game_time)
	get_tree().paused = true


func _on_player_health_changed(current_health: int, max_health: int):
	ui_manager.update_health(current_health, max_health)

func _on_player_exp_changed(current_exp: int, exp_to_next: int):
	ui_manager.update_experience(current_exp, exp_to_next)

func _on_player_level_up(new_level: int):
	ui_manager.update_level(new_level)

func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()