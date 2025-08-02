extends Node

@export_enum( "CISORS", "IRON", "DYE_0", "DYE_1", "DYE_2" ) var tool_to_use
@export var label : Label;

var base_color : Color;

func _ready() -> void:
	base_color = Color.WHITE;
	if (tool_to_use == 0):
		label.text = "CISORS"
	if (tool_to_use == 1):
		label.text = "IRON"
	if (tool_to_use == 2):
		label.text = "DYE_0"
		base_color = GameGlobal.dye_color[0]
	if (tool_to_use == 3):
		label.text = "DYE_1"
		base_color = GameGlobal.dye_color[1]
	if (tool_to_use == 4):
		label.text = "DYE_2"
		base_color = GameGlobal.dye_color[2]
	label.mouse_filter = Control.MOUSE_FILTER_STOP
	label.gui_input.connect(on_input);

func on_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			GameGlobal.set_current_tool(tool_to_use);
	pass;

func _process(delta):
	if (GameGlobal.is_current_tool(tool_to_use)):
		label.scale = Vector2(1.2, 1.2)
		label.modulate.a = 0.8;
	else:
		label.modulate = base_color;
		label.scale = Vector2(1, 1)
	pass
