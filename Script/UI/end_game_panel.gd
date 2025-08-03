extends Control

@export_group("Audio")
@export var ui_restart_sound: AudioStreamPlayer

func _ready():
	self.visible = false;
	pass

func _on_new_game_pressed() -> void:
	
	ui_restart_sound.play()
	
	GameGlobal.reset();
	self.visible = false;
	GlobalSignals.emit_signal("on_game_start");
	pass
