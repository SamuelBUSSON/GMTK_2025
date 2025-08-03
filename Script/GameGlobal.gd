extends Node

enum CurrentTool  { CISORS, IRON, DYE_0, DYE_1, DYE_2 }

@export var dye_color : Array[Color];
@export var game_duration := 5.0;
@export_enum( "CISORS", "IRON", "DYE_0", "DYE_1", "DYE_2" ) var currentTool : int;


var duration;
var current_tool : int;
var current_celebrity : hair_character
var rng := RandomNumberGenerator.new()
var player_score : int;
var is_game_start := false;
var is_game_pause := false;

var viewport_back : SubViewport;
var viewport_front : SubViewport;

var audio_manager : audio_manager;

func get_CISORS_id() -> int:
	return CurrentTool.CISORS;
func get_IRON_id() -> int:
	return CurrentTool.IRON;
func get_DYE_0_id() -> int:
	return CurrentTool.DYE_0;
func get_DYE_1_id() -> int:
	return CurrentTool.DYE_1;
func get_DYE_2_id() -> int:
	return CurrentTool.DYE_2;

func reset():
	duration = game_duration;
	current_tool = 0;
	player_score = 0;
	is_game_start = false;


func _ready():
	duration = game_duration;
	pass

func _process(dt):
	if (is_game_start && !is_game_pause):
		duration -= dt;
		if (duration <= 0.0):
			reset()
			GlobalSignals.emit_signal("on_game_end")
	pass

func is_current_tool(tool_id : int):
	return current_tool == tool_id;

func is_using_cisors() -> bool:
	return current_tool == CurrentTool.CISORS;

func is_using_iron() -> bool:
	return current_tool == CurrentTool.IRON;

func is_using_dye() -> bool:
	return current_tool == CurrentTool.DYE_0 ||  current_tool == CurrentTool.DYE_1 ||  current_tool == CurrentTool.DYE_2;

func get_current_dye_color() -> Color:
	if (current_tool == CurrentTool.DYE_0):
		return dye_color[0];
	if (current_tool == CurrentTool.DYE_1):
		return dye_color[1];
	if (current_tool == CurrentTool.DYE_2):
		return dye_color[2];
	return Color.PINK;

func swap_tool():
	current_tool = current_tool - 1;
	if (current_tool < 0):
		current_tool = CurrentTool.DYE_2;

func set_current_tool(tool_id: int):
	current_tool = tool_id;


func _hair_hash(hair_scene : hair) -> int:
	return _hash(hair_scene.style, hair_scene.size);

func _hash(hair_style : int, hair_size : int) -> int:
	return (hair_style << 8) | hair_size

func get_random_hair_style() -> int:
	return rng.randi_range(0, 1);

func get_random_hair_size() -> int:
	return rng.randi_range(0, 2);

func get_random_hair_hash() -> int:
	return _hash(get_random_hair_style(), get_random_hair_size());

func is_hair_matching(hair_to_test : hair) -> bool:
	for celebrity_hair in current_celebrity.spawned_hair:
		var client_hair_position = hair_to_test.position;
		var celebrity_hair_position = celebrity_hair.position;
		# if it's the same hair
		if (client_hair_position.distance_to(celebrity_hair_position) < 0.05):
			# compare hash
			if (_hair_hash(hair_to_test) != _hair_hash(celebrity_hair)):
				return false;
			# compare color
			if (hair_to_test.hair_color != celebrity_hair.hair_color):
				return false;
			return true;
	return false;

func is_character_matching(character : hair_character) -> bool:
	var matching_hair = 0;
	for client_hair in character.spawned_hair:
		for celebrity_hair in current_celebrity.spawned_hair:
			var client_hair_position = client_hair.position;
			var celebrity_hair_position = celebrity_hair.position;
			# if it's the same hair
			if (client_hair_position.distance_to(celebrity_hair_position) < 0.05):
				# compare hash
				if (_hair_hash(client_hair) != _hair_hash(celebrity_hair)):
					return false;
				# compare color
				if (client_hair.hair_color != celebrity_hair.hair_color):
					return false;
				matching_hair += 1;

	return matching_hair == current_celebrity.spawned_hair.size();
