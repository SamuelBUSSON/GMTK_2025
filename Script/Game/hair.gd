extends Node3D

class_name hair;


enum HairStyle { STRAIGHT, CURLY }
enum HairSize  { SHORT, MEDIUM, LONG }

@export_enum("SHORT", "MEDIUM", "LONG" ) var size: int;
@export_enum("STRAIGHT", "CURLY") var style: int;
# @export var mesh : Mesh;

var hair_color : Color;

func get_mesh() -> MeshInstance3D:
	var mesh = $MeshInstance3D
	return mesh;

func set_mesh(mesh : MeshInstance3D):
	var mesh_instance = $MeshInstance3D
	mesh_instance.scale = mesh.scale;
	mesh_instance.position = mesh.position;


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
	tween.tween_property(mesh_inst, "scale",       original_scale * 1.2, 0.3)

	tween.tween_property(mat,      "albedo_color", original_color, 0.3).set_delay(0.3)
	tween.tween_property(mesh_inst, "scale",       original_scale, 0.3).set_delay(0.3)
	pass;
