extends Control

@onready var global_slider = $SoundBlock/GlobalBlock/GlobalSlider
@onready var global_value = $SoundBlock/GlobalBlock/GlobalValue

@onready var music_slider = $SoundBlock/MusicBlock/MusicSlider
@onready var music_value = $SoundBlock/MusicBlock/MusicValue

@onready var sfx_slider = $SoundBlock/SFXBlock/SFXSlider
@onready var sfx_value = $SoundBlock/SFXBlock/SFXValue

@onready var quit_menu_button = $QuitMenuButton

func open_menu():
	visible = true
	
	#besoin de récupérer les valeurs des deux canaux pour les mettre dans les sliders
	
	global_value.text = str(global_slider.value) + "%"
	music_value.text = str(music_slider.value) + "%"
	sfx_value.text = str(sfx_slider.value) + "%"

func _on_quit_menu_button_pressed() -> void:
	visible = false

func _on_global_slider_value_changed(value: float) -> void:
	#besoin d'update la valeur du canal
	global_value.text = str(value) + "%"

func _on_music_slider_value_changed(value: float) -> void:
	#besoin d'update la valeur du canal
	music_value.text = str(value) + "%"

func _on_sfx_slider_value_changed(value: float) -> void:
	#besoin d'update la valeur du canal
	#ptit bruit de test pour se rendre compte du volume ?
	sfx_value.text = str(value) + "%"

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
