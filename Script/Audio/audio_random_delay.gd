extends AudioStreamPlayer3D

@export var sound_files: Array[AudioStream] = []
@export var min_delay: float = 1.0
@export var max_delay: float = 5.0

func _ready():
	if sound_files.size() > 0:
		play_random_sound()

func play_random_sound():
	var random_sound = sound_files[randi() % sound_files.size()]
	self.stream = random_sound
	self.play()

	var random_delay = randf_range(min_delay, max_delay)
	await get_tree().create_timer(random_delay).timeout
	play_random_sound()
