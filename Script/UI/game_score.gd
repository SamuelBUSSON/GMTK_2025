extends Label

@export var label : Label;

func _process(delta):
    label.text = str("SCORE : ", GameGlobal.player_score)
    pass