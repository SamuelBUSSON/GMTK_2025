extends Control

var rng := RandomNumberGenerator.new()

@onready var dialogue_block = $Dialogue
@onready var dialogue_text = $Dialogue/DialogueText
@onready var dialogue_timer = $Dialogue/DialogueTimer

@onready var photo_block = $Photo
@onready var photo_front_texture = $Photo/PhotoFrontTexture
@onready var photo_back_texture = $Photo/PhotoBackTexture
@onready var photo_star_name = $Photo/PhotoStarName
@onready var photo_timer = $Photo/PhotoTimer
@onready var photo_background_back = $Photo/Background
@onready var photo_background_front = $Photo/Background2

@onready var pause_menu = $PauseMenu
@onready var pause_button = $PauseButton
@export var end_game_panel : Control;

@onready var score_text = $Score/ScoreText


@onready var tool_buttons = [$Toolbar/ScissorsButton,$Toolbar/IronButton,$Toolbar/DyeSprayButton1,$Toolbar/DyeSprayButton2,$Toolbar/DyeSprayButton3]
var button_selected_int = 0

var cursors = {"scissors_1" : load("res://Art/UI/Cursor/sci1.png"),
"scissors_2" : load("res://Art/UI/Cursor/sci2.png"),
"iron_1" : load("res://Art/UI/Cursor/fer1.png"),
"iron_2" : load("res://Art/UI/Cursor/fer2.png"),
"spray_r_1" : load("res://Art/UI/Cursor/spray (6).png"),
"spray_r_2" : load("res://Art/UI/Cursor/spray (5).png"),
"spray_v_1" : load("res://Art/UI/Cursor/spray (2).png"),
"spray_v_2" : load("res://Art/UI/Cursor/spray (1).png"),
"spray_y_1" : load("res://Art/UI/Cursor/spray (4).png"),
"spray_y_2" : load("res://Art/UI/Cursor/spray (3).png")}

var dialogue_pool = ["Make my hair like Braid Pitt's!","Can you make me look like Ponytailor Swift?","Would love the Tony Mohawk cool look!","Antonio Bangderas' cut is what I want.","Take inspiration from Justin Biebun here!","I wanna look like Mullet Cyrus.","I have this photo of Katy Permy, make it similar!","Aim for the Bobert Downey Jr. look...","Could you try and make it like Hairiana Grande?","My reference is Jamie Lee Cutis.","Love the Audrey Auburn vibe.","Just like Ben Coiffleck please.","Copy what Scal Pacino has on his head!","Can my hair be like Orlando Comb's?","I would like to be Trim Cruise's hair twin please!"]
var celebrity_names = ["Braid Pitt","Ponytailor Swift","Tony Mohawk","Antonio Bangderas","Justin Biebun","Mullet Cyrus","Katy Permy","Bobert Downey Jr.","Hairiana Grande","Jamie Lee Cutis","Audrey Auburn","Ben Coiffleck","Scal Pacino","Orlando Comb","Trim Cruise"]

var photo_backgrounds_images = [load("res://UI/Assets/photoV2.png")
,load("res://UI/Assets/photoV2_2.png"),
load("res://UI/Assets/photoV2_3.png")]

func _ready() -> void:
	modulate.a = 0.0
	GlobalSignals.connect("on_game_start", show_ui)
	GlobalSignals.connect("on_new_celebrity", rdm_talk)
	GlobalSignals.connect("on_success_signal", hide_photos)
	GlobalSignals.connect("on_game_end", on_game_end)
	Input.set_custom_mouse_cursor(cursors.get("scissors_1"))
	for i in tool_buttons:
		i.modulate.a = 0.7
	button_selected(0)

func _process(delta: float) -> void:
	change_cursor_on_click()
	photo_front_texture.texture = GameGlobal.viewport_front.get_texture();
	photo_back_texture.texture = GameGlobal.viewport_back.get_texture();
	score_text.text = str("SCORE : ", GameGlobal.player_score)

func show_ui():
	var tween = get_tree().create_tween()
	tween.tween_property($".","modulate",Color(1,1,1,1),0.8)

func on_game_end():
	end_game_panel.visible = true;

func talk(talker_text : String, time_talking : float):
	if !dialogue_block.visible:
		dialogue_block.visible = true
		dialogue_text.text = talker_text
		dialogue_timer.start(time_talking)
	else:
		print("hého, je parle déjà là")

func rdm_talk():
	var tamp = rng.randi_range(0,dialogue_pool.size()-1)
	var dialogueDuration = 4.5;
	if !dialogue_block.visible:
		show_object_with_tween(dialogue_block)
		dialogue_text.text = dialogue_pool[tamp]
		photo_star_name.text = celebrity_names[tamp]
		var other_tween = get_tree().create_tween()
		dialogue_text.set_visible_ratio(0)
		other_tween.tween_property(dialogue_text,"visible_ratio",1,2.0)
		dialogue_timer.start(dialogueDuration)
		var tween = get_tree().create_tween()
		tween.tween_interval(dialogueDuration * 0.6)
		tween.tween_callback(show_photos)
	else:
		print("hého, je parle déjà là")

func _on_dialogue_timer_timeout() -> void:
	hide_object_with_tween(dialogue_block)

func show_photos():
	if !photo_block.visible:
		show_object_with_tween(photo_block)
		# photo_front_texture.texture = photo_front
		# photo_back_texture.texture = photo_back
		#photo_star_name.text = star_name
		var bg = photo_backgrounds_images.pick_random()
		photo_background_back.texture = bg
		photo_background_front.texture = bg

	else:
		print("je montre déjà une photo")

func hide_photos():
	hide_object_with_tween(photo_block)

func _on_photo_timer_timeout() -> void:
	photo_block.visible = false

func _on_pause_button_pressed() -> void:
	Input.set_custom_mouse_cursor(cursors.get("scissors_1"))
	pause_menu.open_menu()
	pause_button.visible = false


func _on_pause_menu_visibility_changed() -> void:
	if !pause_menu.visible:
		pause_button.visible = true
		update_cursor()

func change_cursor_on_click():
	if !pause_menu.visible:
		if Input.is_action_just_pressed("mouse_click"):
			if button_selected_int == 0:
				Input.set_custom_mouse_cursor(cursors.get("scissors_2"))
			elif button_selected_int == 1:
				Input.set_custom_mouse_cursor(cursors.get("iron_2"))
			elif button_selected_int == 2:
				Input.set_custom_mouse_cursor(cursors.get("spray_r_2"))
			elif button_selected_int == 3:
				Input.set_custom_mouse_cursor(cursors.get("spray_v_2"))
			elif button_selected_int == 4:
				Input.set_custom_mouse_cursor(cursors.get("spray_y_2"))
		elif Input.is_action_just_released("mouse_click"):
			if button_selected_int == 0:
				Input.set_custom_mouse_cursor(cursors.get("scissors_1"))
			elif button_selected_int == 1:
				Input.set_custom_mouse_cursor(cursors.get("iron_1"))
			elif button_selected_int == 2:
				Input.set_custom_mouse_cursor(cursors.get("spray_r_1"))
			elif button_selected_int == 3:
				Input.set_custom_mouse_cursor(cursors.get("spray_v_1"))
			elif button_selected_int == 4:
				Input.set_custom_mouse_cursor(cursors.get("spray_y_1"))

func show_object_with_tween(obj : Object):
	var tween = get_tree().create_tween()
	obj.visible = true
	obj.pivot_offset = obj.size/2
	obj.scale = Vector2(0.2,0.2)
	tween.tween_property(obj, "scale", Vector2(1.0,1.0),0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func hide_object_with_tween(obj : Object):
	var tween = get_tree().create_tween()
	obj.pivot_offset = obj.size/2
	tween.tween_property(obj, "scale", Vector2(0.1,0.1),0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(obj, "visible", false, 0)

func button_hovered(id_button : int):
	if button_selected_int != id_button:
		tool_buttons[id_button].modulate.a = 1

func button_neutral(id_button : int):
	if button_selected_int != id_button:
		tool_buttons[id_button].modulate.a = 0.7

func button_selected(id_button : int):
	var other_tween = create_tween()
	other_tween.tween_property(tool_buttons[button_selected_int], "scale", Vector2(1.6,1.6), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	other_tween.tween_property(tool_buttons[button_selected_int], "scale", Vector2(1.0,1.0), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	for i in tool_buttons:
		i.pivot_offset = i.size/2
		i.modulate.a = 0.7

	button_selected_int = id_button
	tool_buttons[id_button].modulate.a = 1
	update_cursor()

	var tween = create_tween()
	tween.tween_property(tool_buttons[id_button], "scale", Vector2(1.6,1.6), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(tool_buttons[id_button], "scale", Vector2(1.4,1.4), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func update_cursor():
	if button_selected_int == 0:
		Input.set_custom_mouse_cursor(cursors.get("scissors_1"))
	elif button_selected_int == 1:
		Input.set_custom_mouse_cursor(cursors.get("iron_1"))
	elif button_selected_int == 2:
		Input.set_custom_mouse_cursor(cursors.get("spray_r_1"))
	elif button_selected_int == 3:
		Input.set_custom_mouse_cursor(cursors.get("spray_v_1"))
	elif button_selected_int == 4:
		Input.set_custom_mouse_cursor(cursors.get("spray_y_1"))

func _on_scissors_button_mouse_entered() -> void:
	button_hovered(0)

func _on_scissors_button_mouse_exited() -> void:
	button_neutral(0)

func _on_scissors_button_pressed() -> void:
	GameGlobal.set_current_tool(0)
	#change cursor
	button_selected(0)
	GlobalSignals.emit_signal("on_tool_select")

func _on_iron_button_mouse_entered() -> void:
	button_hovered(1)

func _on_iron_button_mouse_exited() -> void:
	button_neutral(1)

func _on_iron_button_pressed() -> void:
	GameGlobal.set_current_tool(1)
	#change cursor
	button_selected(1)
	GlobalSignals.emit_signal("on_tool_select")

func _on_dye_spray_button_1_mouse_entered() -> void:
	button_hovered(2)

func _on_dye_spray_button_1_mouse_exited() -> void:
	button_neutral(2)

func _on_dye_spray_button_1_pressed() -> void:
	GameGlobal.set_current_tool(2)
	#change cursor
	button_selected(2)
	GlobalSignals.emit_signal("on_tool_select")

func _on_dye_spray_button_2_mouse_entered() -> void:
	button_hovered(3)

func _on_dye_spray_button_2_mouse_exited() -> void:
	button_neutral(3)

func _on_dye_spray_button_2_pressed() -> void:
	GameGlobal.set_current_tool(3)
	#change cursor
	button_selected(3)
	GlobalSignals.emit_signal("on_tool_select")

func _on_dye_spray_button_3_mouse_entered() -> void:
	button_hovered(4)

func _on_dye_spray_button_3_mouse_exited() -> void:
	button_neutral(4)

func _on_dye_spray_button_3_pressed() -> void:
	GameGlobal.set_current_tool(4)
	#change cursor
	button_selected(4)
	GlobalSignals.emit_signal("on_tool_select")
