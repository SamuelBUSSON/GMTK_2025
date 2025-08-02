extends Node3D

@export var hairs_template: Array[PackedScene]
@export var spawn_positions: Array[Node3D]
@export var max_hair_length: int = 3
@export var min_hair_length: int = 0
@export var angle_variation_degrees: Vector3

var spawned_hair: Array[hair] = []
var rng := RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	_spawn_hair_style()

func _process(delta):
	if Input.is_action_pressed("reroll_hair_style"):
		_spawn_hair_style()

func _spawn_hair_style():
	for h in spawned_hair:
		h.queue_free()
	spawned_hair.clear()

	for spawn_point in spawn_positions:
		var current_pos: Vector3 = spawn_point.global_position
		var current_rot: Vector3 = spawn_point.global_transform.basis.get_euler()
		var nbr_to_spawn = rng.randi_range(min_hair_length, max_hair_length)

		for i in range(nbr_to_spawn):
			var scene = hairs_template.pick_random()
			var new_hair: hair = scene.instantiate() as hair
			add_child(new_hair)

			new_hair.global_position = current_pos
			new_hair.rotation = current_rot

			current_pos = new_hair.top.global_position
			var delta_angle_x = deg_to_rad(rng.randf_range(-angle_variation_degrees.x, angle_variation_degrees.x))
			var delta_angle_y = deg_to_rad(rng.randf_range(-angle_variation_degrees.y, angle_variation_degrees.y))
			var delta_angle_z = deg_to_rad(rng.randf_range(-angle_variation_degrees.z, angle_variation_degrees.z))
			current_rot.x += delta_angle_x
			current_rot.y += delta_angle_y
			current_rot.z += delta_angle_z

			spawned_hair.append(new_hair)
