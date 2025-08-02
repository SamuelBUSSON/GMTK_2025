extends Node

enum CurrentTool  { CISORS, IRON, DYE_0, DYE_1, DYE_2 }

@export var dye_color : Array[Color];
@export_enum( "CISORS", "IRON", "DYE_0", "DYE_1", "DYE_2" ) var currentTool : int;

var current_tool : int;

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