extends Control

var rng := RandomNumberGenerator.new()

@onready var dialogue_block = $Dialogue
@onready var dialogue_text = $Dialogue/DialogueText
@onready var dialogue_timer = $Dialogue/DialogueTimer

@onready var photo_block = $Photo
@onready var photo_front_texture = $Photo/BackgroundFront/PhotoFrontTexture
@onready var photo_back_texture = $Photo/BackgroundBack/PhotoBackTexture
@onready var photo_star_name = $Photo/PhotoStarName
@onready var photo_timer = $Photo/PhotoTimer

@onready var pause_menu = $PauseMenu
@onready var pause_button = $PauseButton


@onready var tool_buttons = [$Toolbar/ScissorsButton,$Toolbar/IronButton,$Toolbar/DyeSprayButton1,$Toolbar/DyeSprayButton2,$Toolbar/DyeSprayButton3]
var button_selected_int = 0

var cursors = {"scissors_1" : load("res://Art/UI/Cursor/sci1.png"),
"scissors_2" : load("res://Art/UI/Cursor/sci2.png"),
"iron_1" : load("res://Art/UI/Cursor/fer1.png"),
"iron_2" : load("res://Art/UI/Cursor/fer2.png"),
"spray_1" : load("res://Art/UI/Cursor/spray1.png"),
"spray_2" : load("res://Art/UI/Cursor/spray2.png")}

var dialogue_pool = ["Make my hair like Braid Pitt's!","Can you make me look like Ponytailor Swift?","Would love the Tony Mohawk cool look!","Antonio Bangderas' cut is what I want.","Take inspiration from Justin Biebun here!","I wanna look like Mullet Cyrus.","I have this photo of Katy Permy, make it similar!","Aim for the Bobert Downey Jr. look...","Could you try and make it like Hairiana Grande?","My reference is Jamie Lee Cutis.","Love the Audrey Auburn vibe.","Just like Ben Coiffleck please."]
var celebrity_names = ["Braid Pitt","Ponytailor Swift","Tony Mohawk","Antonio Bangderas","Justin Biebun","Mullet Cyrus","Katy Permy","Bobert Downey Jr.","Hairiana Grande","Jamie Lee Cutis","Audrey Auburn","Ben Coiffleck"]

func _ready() -> void:
	GlobalSignals.connect("on_new_celebrity", rdm_talk)
	GlobalSignals.connect("on_success_signal", hide_photos)
	Input.set_custom_mouse_cursor(cursors.get("scissors_1"))
	for i in tool_buttons:
		i.modulate.a = 0.7

func _process(delta: float) -> void:
	change_cursor_on_click()
	photo_front_texture.texture = GameGlobal.viewport_front.get_texture();
	photo_back_texture.texture = GameGlobal.viewport_back.get_texture();
	pass;

func talk(talker_text : String, time_talking : float):
	if !dialogue_block.visible:
		dialogue_block.visible = true
		dialogue_text.text = talker_text
		dialogue_timer.start(time_talking)
	else:
		print("hého, je parle déjà là")

func rdm_talk():
	var tamp = rng.randi_range(0,dialogue_pool.size()-1)
	if !dialogue_block.visible:
		dialogue_block.visible = true
		dialogue_text.text = dialogue_pool[tamp]
		photo_star_name.text = celebrity_names[tamp]
		dialogue_timer.start(3.0)
	else:
		print("hého, je parle déjà là")

func _on_dialogue_timer_timeout() -> void:
	dialogue_block.visible = false
	show_photos()

func show_photos():
	if !photo_block.visible:
		photo_block.visible = true
		# photo_front_texture.texture = photo_front
		# photo_back_texture.texture = photo_back
		#photo_star_name.text = star_name
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

func change_cursor_on_click():
	if Input.is_action_just_pressed("mouse_click"):
		if button_selected_int == 0:
			Input.set_custom_mouse_cursor(cursors.get("scissors_2"))
		elif button_selected_int == 1:
			Input.set_custom_mouse_cursor(cursors.get("iron_2"))
		elif button_selected_int >= 2:
			Input.set_custom_mouse_cursor(cursors.get("spray_2"))
	elif Input.is_action_just_released("mouse_click"):
		if button_selected_int == 0:
			Input.set_custom_mouse_cursor(cursors.get("scissors_1"))
		elif button_selected_int == 1:
			Input.set_custom_mouse_cursor(cursors.get("iron_1"))
		elif button_selected_int >= 2:
			Input.set_custom_mouse_cursor(cursors.get("spray_1"))

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

	if id_button == 0:
		Input.set_custom_mouse_cursor(cursors.get("scissors_1"))
	elif id_button == 1:
		Input.set_custom_mouse_cursor(cursors.get("iron_1"))
	elif id_button >= 2:
		Input.set_custom_mouse_cursor(cursors.get("spray_1"))

	button_selected_int = id_button
	tool_buttons[id_button].modulate.a = 1

	var tween = create_tween()
	tween.tween_property(tool_buttons[id_button], "scale", Vector2(1.4,1.4), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

func _on_scissors_button_mouse_entered() -> void:
	button_hovered(0)

func _on_scissors_button_mouse_exited() -> void:
	button_neutral(0)

func _on_scissors_button_pressed() -> void:
	GameGlobal.set_current_tool(0)
	#change cursor
	button_selected(0)

func _on_iron_button_mouse_entered() -> void:
	button_hovered(1)

func _on_iron_button_mouse_exited() -> void:
	button_neutral(1)

func _on_iron_button_pressed() -> void:
	GameGlobal.set_current_tool(1)
	#change cursor
	button_selected(1)

func _on_dye_spray_button_1_mouse_entered() -> void:
	button_hovered(2)

func _on_dye_spray_button_1_mouse_exited() -> void:
	button_neutral(2)

func _on_dye_spray_button_1_pressed() -> void:
	GameGlobal.set_current_tool(2)
	#change cursor
	button_selected(2)

func _on_dye_spray_button_2_mouse_entered() -> void:
	button_hovered(3)

func _on_dye_spray_button_2_mouse_exited() -> void:
	button_neutral(3)

func _on_dye_spray_button_2_pressed() -> void:
	GameGlobal.set_current_tool(3)
	#change cursor
	button_selected(3)

func _on_dye_spray_button_3_mouse_entered() -> void:
	button_hovered(4)

func _on_dye_spray_button_3_mouse_exited() -> void:
	button_neutral(4)

func _on_dye_spray_button_3_pressed() -> void:
	GameGlobal.set_current_tool(4)
	#change cursor
	button_selected(4)
