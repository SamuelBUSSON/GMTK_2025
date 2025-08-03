extends Control

@onready var animation_player = $AnimationPlayer

@export_group("Audio")
@export var ui_start_sound: AudioStreamPlayer

func _ready() -> void:
	pivot_offset = size/2

func _on_start_button_pressed() -> void:
	
	ui_start_sound.play()
	
	animation_player.play("startgame")
	GlobalSignals.emit_signal("on_game_start");
	#on start le jeu

func start_game():
	visible = false
