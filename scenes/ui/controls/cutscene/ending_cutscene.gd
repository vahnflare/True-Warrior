extends Node2D

@onready var text_label: Label = $DialogueUI/Panel/DialogueLabel
@onready var music: AudioStreamPlayer2D = $AudioStreamPlayer
@onready var color_rect: ColorRect = $ColorRect

var dialogue: Array[String] = [
	"The last one falls.",
	"The streets are silent.",
	"You fought through them all.",
	"You survived.",
	"True Warrior."
]

var index: int = 0
var is_typing: bool = false

func _ready() -> void:
	color_rect.color = Color(0, 0, 0, 1)
	await fade_in()
	show_text()
	music.play()

func fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 0), 1.5)
	await tween.finished

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
				end_game()

func end_game() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 1), 1.5)
	tween.tween_property(music, "volume_db", -80.0, 1.5)
	await tween.finished
	music.stop()
	get_tree().quit()
