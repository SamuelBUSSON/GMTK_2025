extends Node3D

class_name hair_character

@export var spawn_positions: Array[Node3D]
@export var angle_variation_degrees: Vector3
@export var hair_styles: Array[PackedScene];

@export var is_celebrity : bool

var spawned_hair: Array[hair] = []
var rng := RandomNumberGenerator.new()

var hairLookUp : Dictionary;
var hairMeshLookUp : Dictionary;


func _ready():
	rng.randomize()

	for scene in hair_styles:
		var new_hair: hair = scene.instantiate() as hair
		var hair_hash = GameGlobal._hash(new_hair.style, new_hair.size);
		hairLookUp[hair_hash] = scene;
		hairMeshLookUp[hair_hash] = new_hair.get_mesh()

	_spawn_hair_style()

	if (!is_celebrity):
		GlobalSignals.connect("on_hair_click", on_hair_click)
	else:
		GameGlobal.current_celebrity = self;


func on_hair_click(hair_click : hair):
	if (GameGlobal.is_using_cisors()):
		var size = hair_click.size;
		hair_click.size =  hair_click.size - 1;
		if (hair_click.size < 0):
			hair_click.size = 2;

		replace_air_mesh(hair_click);
		return

	if (GameGlobal.is_using_dye()):
		var dye_color = GameGlobal.get_current_dye_color();
		hair_click.set_mesh_color(dye_color);

	if (GameGlobal.is_using_iron()):
		hair_click.style = hair_click.style - 1;
		if (hair_click.style < 0):
			hair_click.style = 1;
		replace_air_mesh(hair_click);

	# increment score + switch character
	if (GameGlobal.is_character_matching(self)):
		print("Bravo !");
		_spawn_hair_style();
		pass;

	pass;

func replace_air_mesh(hair_click : hair):
	var new_hash = GameGlobal._hair_hash(hair_click);
	var new_hair_mesh = hairMeshLookUp[new_hash];
	hair_click.set_mesh(new_hair_mesh);

func remove_hair(h: hair) -> void:
	if spawned_hair.has(h):
		spawned_hair.erase(h)
		h.queue_free()

func _process(delta):
	if (is_celebrity):
		return;

	if Input.is_action_just_pressed("mouse_click"):
		_select_at_screen(get_viewport().get_mouse_position())
	if Input.is_action_just_pressed("reroll_hair_style"):
		_spawn_hair_style()
	if Input.is_action_just_pressed("swap_tool"):
		GameGlobal.swap_tool()





func _spawn_hair_style():
	for h in spawned_hair:
		h.queue_free()
	spawned_hair.clear()

	for spawn_point in spawn_positions:
		var current_pos: Vector3 = spawn_point.global_position
		var current_rot: Vector3 = spawn_point.global_transform.basis.get_euler()
		var hair_hash_to_spawn = GameGlobal.get_random_hair_hash()
		var hair_to_spawn = hairLookUp[hair_hash_to_spawn];

		var new_hair:hair = hair_to_spawn.instantiate() as hair
		new_hair.set_mesh_color(GameGlobal.dye_color.pick_random());

		add_child(new_hair)
		new_hair.global_position = current_pos
		var delta_angle_x = deg_to_rad(rng.randf_range(-angle_variation_degrees.x, angle_variation_degrees.x))
		var delta_angle_y = deg_to_rad(rng.randf_range(-angle_variation_degrees.y, angle_variation_degrees.y))
		var delta_angle_z = deg_to_rad(rng.randf_range(-angle_variation_degrees.z, angle_variation_degrees.z))

		new_hair.rotation = current_rot
		new_hair.rotation.x =  delta_angle_x
		new_hair.rotation.y =  delta_angle_y
		new_hair.rotation.z =  delta_angle_z

		spawned_hair.append(new_hair)

func _select_at_screen(mouse_pos: Vector2) -> void:
	var cam = get_viewport().get_camera_3d()
	if cam == null:
		return

	var origin: Vector3 = cam.project_ray_origin(mouse_pos)
	var to: Vector3 = origin + cam.project_ray_normal(mouse_pos) * 1000

	var query = PhysicsRayQueryParameters3D.create(origin, to)
	query.collide_with_bodies = true

	var world = get_world_3d().direct_space_state
	var result = world.intersect_ray(query)

	if result.size() > 0:
		var obj = result["collider"] as CollisionObject3D
		var hair_node = _find_hair_owner(obj)
		if hair_node:
			GlobalSignals.emit_signal("on_hair_click", hair_node);



func _find_hair_owner(obj: Object) -> hair:
	if not obj is Node:
		return null

	var node := obj as Node
	while node:
		if node is hair:
			return node as hair
		node = node.get_parent()
	return null
