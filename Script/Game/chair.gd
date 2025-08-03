extends Node3D

@export var spinning_speed: float = 1.0;
@export var mouse_click_scale_speed: float = 4.0;
@export var scale_speed_based_on_score: float = 0.75;

func _process(dt):
	if (GameGlobal.is_game_pause):
		return
	if (GameGlobal.is_game_start):
		var speed = spinning_speed + GameGlobal.player_score * scale_speed_based_on_score;
		if Input.is_action_pressed("mouse_click_right"):
			self.rotate_y(speed * dt * mouse_click_scale_speed)
		else:
			self.rotate_y(speed * dt)
	pass