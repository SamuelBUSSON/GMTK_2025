extends Control

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	pivot_offset = size/2

func _on_start_button_pressed() -> void:
	animation_player.play("startgame")
	#on start le jeu

func start_game():
	visible = false
