extends Control

@export var world_scene: PackedScene
@export var cutscene_scene: PackedScene

func _ready() -> void:
	var start_btn := find_child("Start", true, false)
	if start_btn:
		start_btn.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		var focused := get_viewport().gui_get_focus_owner()
		if focused != null and focused.name == "Quit":
			get_tree().quit()
		else:
			start_game()
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_start_pressed() -> void:
	start_game()

func _on_quit_pressed() -> void:
	get_tree().quit()

func start_game() -> void:
	if cutscene_scene == null:
		push_error("cutscene_scene is not assigned in TitleScreen inspector!")
		return
	get_tree().change_scene_to_packed(cutscene_scene)
