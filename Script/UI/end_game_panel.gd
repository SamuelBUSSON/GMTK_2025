extends Control

func _ready():
	self.visible = false;
	pass

func _on_new_game_pressed() -> void:
	GameGlobal.reset();
	self.visible = false;
	GlobalSignals.emit_signal("on_game_start");
	pass
