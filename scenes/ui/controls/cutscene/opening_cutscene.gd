extends Node2D

@export var world_scene: PackedScene

@onready var text_label: Label = $DialogueUI/Panel/DialogueLabel
@onready var music: AudioStreamPlayer2D = $AudioStreamPlayer
@onready var color_rect: ColorRect = $ColorRect

var dialogue: Array[String] = [
	"Dark streets. Surrounded on all sides.",
	"They thought you were just another target.",
	"They were wrong.",
	"Fight through every wave. Trust no one.",
	"Survive the streets. Prove you are the True Warrior."
]

var index: int = 0
var is_typing: bool = false

func _ready() -> void:
	color_rect.color = Color(0, 0, 0, 0)
	show_text()
	music.play()

func show_text() -> void:
	is_typing = true
	text_label.text = ""
	for ch in dialogue[index]:
		text_label.text += ch
		await get_tree().create_timer(0.045).timeout
	is_typing = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			text_label.text = dialogue[index]
			is_typing = false
		else:
			index += 1
			if index < dialogue.size():
				show_text()
			else:
				end_cutscene()

func end_cutscene() -> void:
	var tween := create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 1), 0.8)
	await tween.finished
	if world_scene == null:
		push_error("world_scene is not assigned!")
		return
	get_tree().change_scene_to_packed(world_scene)
