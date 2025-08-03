extends Label

@export var label : Label;

func _process(delta):
	label.text = str("Customers satisfied : ", GameGlobal.player_score)
	pass
