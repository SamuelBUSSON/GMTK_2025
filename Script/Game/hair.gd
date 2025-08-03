extends Node3D

class_name hair;


enum HairStyle { STRAIGHT, CURLY }
enum HairSize  { SHORT, MEDIUM, LONG }

@export_enum("SHORT", "MEDIUM", "LONG" ) var size: int;
@export_enum("STRAIGHT", "CURLY") var style: int;

var hair_color : Color;
var lock : bool;
var spawn_nodex_index : int;
var select : bool;
var outline_mat : StandardMaterial3D;
var outline_base_color = Color.BLACK;

func _ready():
	var outline_mesh : MeshInstance3D = %Outline
	var base_mat = outline_mesh.material_override
	if base_mat:
		outline_mat = base_mat.duplicate(true) as StandardMaterial3D
	else:
		outline_mat = StandardMaterial3D.new()
	outline_mesh.material_override = outline_mat;

func get_mesh() -> MeshInstance3D:
	var mesh = $MeshInstance3D
	return mesh;

func set_mesh(mesh : MeshInstance3D):
	var mesh_instance = $MeshInstance3D
	mesh_instance.scale = mesh.scale;
	mesh_instance.position = mesh.position;
	mesh_instance.mesh = mesh.mesh;

func select_hair_mesh(is_selected : bool):
	if select == is_selected:
		return
	select = is_selected

	var target_color =   Color.WHITE if is_selected else outline_base_color
	outline_mat.albedo_color = target_color


func set_mesh_color(color : Color):
	var mesh = $MeshInstance3D
	var mat = mesh.get_active_material(0)
	if mat == null:
		mat = StandardMaterial3D.new()
		mesh.set_surface_override_material(0, mat)
	else:
		mat = mat.duplicate()
		mesh.set_surface_override_material(0, mat)

	mat.albedo_color = color
	hair_color = color;

func on_hair_match_event():
	if (lock):
		return
	var mesh_inst = $MeshInstance3D
	var mat = mesh_inst.get_active_material(0)
	if mat == null:
		mat = StandardMaterial3D.new()
		mesh_inst.set_surface_override_material(0, mat)
	else:
		mat = mat.duplicate()
		mesh_inst.set_surface_override_material(0, mat)

	var original_color = mat.albedo_color
	var original_scale = mesh_inst.scale

	var tween = create_tween()

	tween.tween_property(mat,      "albedo_color", Color.WHITE, 0.3)
	tween.parallel().tween_property(mesh_inst, "scale",       original_scale * 1.2, 0.3)

	tween.tween_property(mat,      "albedo_color", original_color, 0.3).set_delay(0.3)
	tween.parallel().tween_property(mesh_inst, "scale",       original_scale, 0.3).set_delay(0.3)

	tween.tween_callback(free_lock);
	lock = true;
	pass;

func set_outline_base_color(new_col : Color):
	outline_base_color = new_col;
	pass

func free_lock() -> void:
	lock = false;
