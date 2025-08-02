extends Control

@onready var dialogue_block = $Dialogue
@onready var dialogue_name = $Dialogue/DialogueName
@onready var dialogue_text = $Dialogue/DialogueText
@onready var dialogue_timer = $Dialogue/DialogueTimer

@onready var photo_block = $Photo
@onready var photo_front_texture = $Photo/PhotoFrontTexture
@onready var photo_back_texture = $Photo/PhotoBackTexture
@onready var photo_timer = $Photo/PhotoTimer

@onready var pause_menu = $PauseMenu
@onready var pause_button = $PauseButton

@onready var tool_buttons = [$Toolbar/ScissorsButton,$Toolbar/IronButton,$Toolbar/DyeSprayButton1,$Toolbar/DyeSprayButton2,$Toolbar/DyeSprayButton3]
var button_selected_int = -1

func _ready() -> void:
	for i in tool_buttons:
		i.modulate.a = 0.7

func talk(talker_name : String, talker_text : String, time_talking : float):
	if !dialogue_block.visible:
		dialogue_block.visible = true
		dialogue_name.text = talker_name
		dialogue_text.text = talker_text
		dialogue_timer.start(time_talking)
	else:
		print("hého, je parle déjà là")

func _on_dialogue_timer_timeout() -> void:
	dialogue_block.visible = false

func show_photos(photo_front : TextureRect, photo_back : TextureRect, star_name : float):
	if !photo_block.visible:
		photo_block.visible = true
		photo_front_texture.texture = photo_front
		photo_back_texture.texture = photo_back
	else:
		print("je montre déjà une photo")

func hide_photos():
	photo_block.visible = false

func _on_photo_timer_timeout() -> void:
	photo_block.visible = false

func _on_pause_button_pressed() -> void:
	pause_menu.visible = true
	pause_button.visible = false

func _on_pause_menu_visibility_changed() -> void:
	if !pause_menu.visible:
		pause_button.visible = true

func button_hovered(id_button : int):
	if button_selected_int != id_button:
		tool_buttons[id_button].modulate.a = 1

func button_neutral(id_button : int):
	if button_selected_int != id_button:
		tool_buttons[id_button].modulate.a = 0.7

func button_selected(id_button : int):
	for i in tool_buttons:
		i.scale = Vector2(1.0,1.0)
		i.pivot_offset = i.size/2
		i.modulate.a = 0.7
		
	button_selected_int = id_button
	tool_buttons[id_button].modulate.a = 1
	tool_buttons[id_button].scale = Vector2(1.4,1.4)

func _on_scissors_button_mouse_entered() -> void:
	button_hovered(0)

func _on_scissors_button_mouse_exited() -> void:
	button_neutral(0)

func _on_scissors_button_pressed() -> void:
	#tool mode
	#change cursor
	button_selected(0)

func _on_iron_button_mouse_entered() -> void:
	button_hovered(1)

func _on_iron_button_mouse_exited() -> void:
	button_neutral(1)

func _on_iron_button_pressed() -> void:
	#tool mode
	#change cursor
	button_selected(1)

func _on_dye_spray_button_1_mouse_entered() -> void:
	button_hovered(2)

func _on_dye_spray_button_1_mouse_exited() -> void:
	button_neutral(2)

func _on_dye_spray_button_1_pressed() -> void:
	#tool mode
	#change cursor
	button_selected(2)

func _on_dye_spray_button_2_mouse_entered() -> void:
	button_hovered(3)

func _on_dye_spray_button_2_mouse_exited() -> void:
	button_neutral(3)

func _on_dye_spray_button_2_pressed() -> void:
	#tool mode
	#change cursor
	button_selected(3)

func _on_dye_spray_button_3_mouse_entered() -> void:
	button_hovered(4)

func _on_dye_spray_button_3_mouse_exited() -> void:
	button_neutral(4)

func _on_dye_spray_button_3_pressed() -> void:
	#tool mode
	#change cursor
	button_selected(4)
