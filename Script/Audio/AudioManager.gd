extends Node

class_name audio_manager;

@export var audio_descriptor: Array[audio_description]
@export var audio_stream: PackedScene;

class pooled_audio:
	var audio_resource: audio_description;
	var stream: AudioStreamPlayer3D;

class pooled_audio_array:
	var array: Array[pooled_audio];
	var current_pitch: int = 0;
	var reverse_pitch: bool = false;


var spawned_audio: Dictionary = {};
var audio_descriptor_dico: Dictionary = {};

var is_playing_menu = false;

func _ready() -> void:
	for i in range(0, audio_descriptor.size()):
		var audio_resource: audio_description = audio_descriptor[i];
		# print("Add audio asset - " + audio_resource.audio_id)
		audio_descriptor_dico[audio_resource.audio_id] = audio_resource;
		pass


func get_from_pool_or_spawn(audio_id: String) -> pooled_audio:
	var audio_resource_to_use = audio_descriptor_dico.get(audio_id);
	if (!spawned_audio.has(audio_id)):
		if (audio_resource_to_use == null):
			return null;

		var new_pooled_item = pooled_audio.new();
		new_pooled_item.audio_resource = audio_resource_to_use;
		new_pooled_item.stream = audio_stream.instantiate();
		add_child(new_pooled_item.stream);

		var new_pool_array = pooled_audio_array.new();
		new_pool_array.array.append(new_pooled_item);

		spawned_audio[audio_id] = new_pool_array;
		return new_pooled_item;

	var audio_pool: pooled_audio_array = spawned_audio.get(audio_id);

	if (audio_pool.array[0].stream.playing && !audio_pool.array[0].audio_resource.can_be_played_multiple_time):
		return ;

	for i in range(0, audio_pool.array.size()):
		var pool_object: pooled_audio = audio_pool.array[i];
		if (!pool_object.stream.playing):

			if (pool_object.audio_resource.increase_pitch_on_each_play):
				pool_object.stream.pitch_scale = audio_pool.current_pitch;
				if (audio_pool.current_pitch >= 5 || audio_pool.current_pitch < 0):
					audio_pool.reverse_pitch = !audio_pool.reverse_pitch;
				if (audio_pool.reverse_pitch):
					audio_pool.current_pitch -= 1;
				else:
					audio_pool.current_pitch += 1;

			return pool_object;
		pass

	var new_pooled_item_bis = pooled_audio.new();
	new_pooled_item_bis.audio_resource = audio_resource_to_use;
	new_pooled_item_bis.stream = audio_stream.instantiate();
	add_child(new_pooled_item_bis.stream);
	audio_pool.array.append(new_pooled_item_bis);

	return new_pooled_item_bis;

func request_audio(audio_id: String, position : Vector3):
	var audio_to_spawn = get_from_pool_or_spawn(audio_id);
	if (audio_to_spawn == null):
		return

	audio_to_spawn.stream.position = position;
	audio_to_spawn.stream.stream = audio_to_spawn.audio_resource.audio_to_play.pick_random();
	audio_to_spawn.stream.play();
	pass ;
