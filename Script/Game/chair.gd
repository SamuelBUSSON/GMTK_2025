extends Node3D

@export var spinning_speed: float = 1.0;


func _process(dt):
	self.rotate_y(spinning_speed * dt)
	pass