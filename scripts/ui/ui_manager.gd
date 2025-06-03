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
@onready var patch_description: Label = $PatchPanel/VBoxContainer/PatchDescription
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

func show_patch_notes(patch_data: Dictionary):
	if not patch_panel:
		return
	
	# Pause the game for dramatic effect
	get_tree().paused = true
	
	# Fill in patch information
	if patch_title:
		patch_title.text = patch_data.title
	
	if patch_description:
		patch_description.text = patch_data.description
	
	if patch_changes:
		var changes_text = "[color=yellow]PATCH NOTES:[/color]\n\n"
		for change in patch_data.changes:
			changes_text += change + "\n"
		changes_text += "\n[color=red]Changes applied immediately![/color]"
		patch_changes.text = changes_text
	
	# Show the panel
	patch_panel.visible = true
	
	# Add some dramatic effects
	create_patch_effects()

func create_patch_effects():
	# Create a tween for dramatic entrance
	var tween = create_tween()
	if patch_panel:
		patch_panel.modulate.a = 0.0
		patch_panel.scale = Vector2(0.8, 0.8)
		
		tween.parallel().tween_property(patch_panel, "modulate:a", 1.0, 0.3)
		tween.parallel().tween_property(patch_panel, "scale", Vector2(1.0, 1.0), 0.3)
		tween.tween_callback(func(): print("PATCH DEPLOYED!"))

func _on_patch_close_pressed():
	if patch_panel:
		patch_panel.visible = false
	
	# Resume the game
	get_tree().paused = false

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
