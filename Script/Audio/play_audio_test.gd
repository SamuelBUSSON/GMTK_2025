extends Node3D

@export var audio_id : String;
@export var cooldown : float = 1.0;

var elapsed = 0.0;

func _process(dt):
	elapsed += dt;
	if (elapsed >= cooldown):
		elapsed = 0.0;
		AudioManager.request_audio(audio_id, self.position)
	pass
