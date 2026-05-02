extends Node

const SAVE_PATH = "user://save.sav"

signal game_loaded
signal game_saved

var current_save : Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [],
	quest = [],
}

func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not open save file for writing!")
		return
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	file.close()
	game_saved.emit()
	print("Game saved!")

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		push_error("No save file found!")
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Could not open save file for reading!")
		return
	var json_string = file.get_line()
	file.close()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		push_error("Could not parse save file!")
		return
	current_save = json.get_data()
	game_loaded.emit()
	print("Game loaded!")
	get_tree().change_scene_to_file(current_save.scene_path)
