extends Control
class_name UIManager

@onready var health_bar: ProgressBar = $HealthBar
@onready var exp_bar: ProgressBar = $ExpBar
@onready var level_label: Label = $LevelLabel
@onready var time_label: Label = $TimeLabel
@onready var game_over_panel: Panel = $GameOverPanel
@onready var final_time_label: Label = $GameOverPanel/VBoxContainer/FinalTimeLabel
@onready var restart_button: Button = $GameOverPanel/VBoxContainer/RestartButton

# Patch notes UI
@onready var patch_panel: Panel = $PatchPanel
@onready var patch_title: Label = $PatchPanel/VBoxContainer/PatchTitle
@onready var patch_changes: RichTextLabel = $PatchPanel/VBoxContainer/PatchChanges
@onready var patch_close_button: Button = $PatchPanel/VBoxContainer/CloseButton

func _ready():
	restart_button.pressed.connect(_on_restart_pressed)
	patch_close_button.pressed.connect(_on_patch_close_pressed)
	game_over_panel.visible = false
	patch_panel.visible = false

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
		var minutes = int(time / 60)
		var seconds = int(time) % 60
		time_label.text = "Time: %02d:%02d" % [minutes, seconds]

func show_game_over(final_time: float):
	if game_over_panel:
		game_over_panel.visible = true
	
	if final_time_label:
		var minutes = int(final_time / 60)
		var seconds = int(final_time) % 60
		final_time_label.text = "Survived: %02d:%02d" % [minutes, seconds]

func show_patch_notes(title: String, changes_text: String):
	# Pause the game for dramatic effect
	get_tree().paused = true
	
	patch_title.text = title
	patch_changes.text = changes_text
	
	# Show the panel
	patch_panel.visible = true

func _on_patch_close_pressed():
	patch_panel.visible = false
	get_tree().paused = false

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
