extends Control

func _ready():
	self.visible = false;
	pass

func _on_new_game_pressed() -> void:
	get_tree().reload_current_scene()
	GameGlobal.is_game_start = false;
	pass
