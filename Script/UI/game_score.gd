extends Label

@export var label : Label;

func _process(delta):
	label.text = str("Score : ", GameGlobal.player_score)
	pass
