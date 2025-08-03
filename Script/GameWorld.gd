extends Node3D

@export var viewport_front : SubViewport;
@export var viewport_back : SubViewport;

func _ready():
	GameGlobal.viewport_front = self.viewport_front;
	GameGlobal.viewport_back = self.viewport_back;
	pass
