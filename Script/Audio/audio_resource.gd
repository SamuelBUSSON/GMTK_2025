extends Resource

class_name audio_description;

@export var audio_id : String;
@export var can_be_played_multiple_time : bool = true;
@export var increase_pitch_on_each_play : bool = false;
@export var audio_to_play : Array[Resource];