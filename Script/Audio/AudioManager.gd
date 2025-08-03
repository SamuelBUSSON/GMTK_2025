extends Node

class_name audio_manager;

@export var audioPlayer: AudioStreamPlayer3D;

@export var cisors_select_sounds: Array[AudioStream] = []
@export var dye_select_sounds: Array[AudioStream] = []
@export var iron_select_sounds: Array[AudioStream] = []

@export var cisors_use_sounds: Array[AudioStream] = []
@export var dye_use_sounds: Array[AudioStream] = []
@export var iron_use_sounds: Array[AudioStream] = []

enum CurrentTool  { CISORS, IRON, DYE }

var current_tool: CurrentTool = CurrentTool.CISORS
var is_looping: bool = false

func _ready() -> void:
		GlobalSignals.connect("is_using_cisors", on_using_cisors)
		GlobalSignals.connect("is_using_dye", on_using_dye)
		GlobalSignals.connect("is_using_iron", on_using_iron)
		GlobalSignals.connect("on_tool_select", on_tool_selected)

func on_using_cisors():
	current_tool = CurrentTool.CISORS
	play_tool_use_sound()

func on_using_dye():
	current_tool = CurrentTool.DYE
	play_tool_use_sound()
	
func on_using_iron():
	current_tool = CurrentTool.IRON
	play_tool_use_sound()
	
func on_tool_selected():
	play_tool_select_sound()
	
func play_tool_select_sound():
	var sound_array: Array[AudioStream] = []
	
	if GameGlobal.is_using_cisors():
		sound_array = cisors_select_sounds
	if GameGlobal.is_using_dye():
		sound_array = dye_select_sounds
	if GameGlobal.is_using_iron():
		sound_array = iron_select_sounds
	
	if sound_array.size() > 0:
		var random_sound = sound_array[randi() % sound_array.size()]
		audioPlayer.stream = random_sound
		audioPlayer.play()
		
func play_tool_use_sound():
	var sound_array: Array[AudioStream] = []
	
	if GameGlobal.is_using_cisors():
		sound_array = cisors_use_sounds
	if GameGlobal.is_using_dye():
		sound_array = dye_use_sounds
	if GameGlobal.is_using_iron():
		sound_array = iron_use_sounds
	
	if sound_array.size() > 0:
		var random_sound = sound_array[randi() % sound_array.size()]
		audioPlayer.stream = random_sound
		audioPlayer.play()

func play_hair_matching():
	var sound_array: Array[AudioStream] = []
	
	if sound_array.size() > 0:
		var random_sound = sound_array[randi() % sound_array.size()]
		audioPlayer.stream = random_sound
		audioPlayer.play()
