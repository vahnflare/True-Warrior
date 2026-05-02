extends CharacterBody2D

@export var dialogue_text: String = "Offlimits!"

@onready var interaction_area: Area2D = $InteractionArea
@onready var dialogue_panel: Control = $DialogueUI/Panel
@onready var dialogue_label: Label = $DialogueUI/Panel/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player_in_range: bool = false
var is_talking: bool = false


func _ready():
	# Hide dialogue at start
	dialogue_panel.visible = false

	# Connect signals (IMPORTANT)
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)


func _input(event):
	if player_in_range and event.is_action_pressed("dialogic_default_action"):
		if is_talking:
			end_dialogue()
		else:
			start_dialogue()


func start_dialogue():
	is_talking = true
	dialogue_label.text = dialogue_text
	dialogue_panel.visible = true
	
	# Optional: play talk animation
	if animation_player.has_animation("talk"):
		animation_player.play("talk")


func end_dialogue():
	is_talking = false
	dialogue_panel.visible = false
	
	# Optional: return to idle
	if animation_player.has_animation("idle"):
		animation_player.play("idle")


func _on_body_entered(body):
	if body.is_in_group("player"):
		print("PLAYER DETECTED")
		player_in_range = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		end_dialogue()  
