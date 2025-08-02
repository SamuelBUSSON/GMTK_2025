extends Node3D

class_name hair;


enum HairStyle { STRAIGHT, CURLY }
enum HairSize  { SHORT, MEDIUM, LONG }

@export_enum("SHORT", "MEDIUM", "LONG" ) var size: int;
@export_enum("STRAIGHT", "CURLY") var style: int;
# @export var mesh : Mesh;

var hair_color : Color;


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
