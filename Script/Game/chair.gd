extends Node3D

@export var spinning_speed: float = 1.0;
@export var mouse_click_scale_speed: float = 4.0;

func _process(dt):
	if (GameGlobal.is_game_start):

		var speed = spinning_speed + GameGlobal.player_score * 0.5;
		if Input.is_action_pressed("mouse_click_right"):
			self.rotate_y(speed * dt * mouse_click_scale_speed)
		else:
			self.rotate_y(speed * dt)
	pass