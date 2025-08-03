extends Control

@onready var global_slider = $MenuBlock/SoundBlock/GlobalBlock/GlobalSlider
@onready var global_value = $MenuBlock/SoundBlock/GlobalBlock/GlobalValue

@onready var music_slider = $MenuBlock/SoundBlock/MusicBlock/MusicSlider
@onready var music_value = $MenuBlock/SoundBlock/MusicBlock/MusicValue

@onready var sfx_slider = $MenuBlock/SoundBlock/SFXBlock/SFXSlider
@onready var sfx_value = $MenuBlock/SoundBlock/SFXBlock/SFXValue

@onready var quit_menu_button = $MenuBlock/QuitMenuButton

@onready var menu_block = $MenuBlock

func open_menu():
	visible = true
	var tween = get_tree().create_tween()
	menu_block.pivot_offset = menu_block.size/2
	menu_block.scale = Vector2(0.2,0.2)
	tween.tween_property(menu_block, "scale", Vector2(1.3,1.3),0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(menu_block, "scale", Vector2(1.0,1.0),0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#besoin de récupérer les valeurs des deux canaux pour les mettre dans les sliders
	
	global_value.text = str(global_slider.value).pad_decimals(0) + "%"
	music_value.text = str(music_slider.value).pad_decimals(0) + "%"
	sfx_value.text = str(sfx_slider.value).pad_decimals(0) + "%"

func _on_quit_menu_button_pressed() -> void:
	var tween = get_tree().create_tween()
	menu_block.pivot_offset = menu_block.size/2
	tween.tween_property(menu_block, "scale", Vector2(1.3,1.3),0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(menu_block, "scale", Vector2(0.0,0.0),0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property($".", "visible", false, 0)

func _on_global_slider_value_changed(value: float) -> void:
	#besoin d'update la valeur du canal
	global_value.text = str(value).pad_decimals(0) + "%"

func _on_music_slider_value_changed(value: float) -> void:
	#besoin d'update la valeur du canal
	music_value.text = str(value).pad_decimals(0) + "%"

func _on_sfx_slider_value_changed(value: float) -> void:
	#besoin d'update la valeur du canal
	#ptit bruit de test pour se rendre compte du volume ?
	sfx_value.text = str(value).pad_decimals(0) + "%"

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
