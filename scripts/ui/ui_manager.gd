extends Control
class_name UIManager

@onready var health_bar: ProgressBar = $HealthBar
@onready var exp_bar: ProgressBar = $ExpBar
@onready var level_label: Label = $LevelLabel
@onready var time_label: Label = $TimeLabel
@onready var game_over_panel: Panel = $GameOverPanel
@onready var final_time_label: Label = $GameOverPanel/VBoxContainer/FinalTimeLabel
@onready var restart_button: Button = $GameOverPanel/VBoxContainer/RestartButton

func _ready():
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	
	if game_over_panel:
		game_over_panel.visible = false

func update_health(current_health: int, max_health: int):
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health

func update_experience(current_exp: int, exp_to_next: int):
	if exp_bar:
		exp_bar.max_value = exp_to_next
		exp_bar.value = current_exp

func update_level(level: int):
	if level_label:
		level_label.text = "Level: " + str(level)

func update_time(time: float):
	if time_label:
		var minutes = int(time) / 60
		var seconds = int(time) % 60
		time_label.text = "Time: %02d:%02d" % [minutes, seconds]

func show_game_over(final_time: float):
	if game_over_panel:
		game_over_panel.visible = true
	
	if final_time_label:
		var minutes = int(final_time) / 60
		var seconds = int(final_time) % 60
		final_time_label.text = "Survived: %02d:%02d" % [minutes, seconds]

func _on_restart_pressed():
	get_tree().reload_current_scene() 