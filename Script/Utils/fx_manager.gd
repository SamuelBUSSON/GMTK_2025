extends Node

class_name fx_manager;

class pool_fx:
	var spawned_fx: Node3D;

@export var fx_descriptor: Array[fx_description]

var spawned_fx: Dictionary = {};
var fx_descriptor_dico: Dictionary = {};


func _ready() -> void:
	for i in range(0, fx_descriptor.size()):
		var fx_resource: fx_description = fx_descriptor[i];
		fx_descriptor_dico[fx_resource.fx_id] = fx_resource.fx_scene;
		pass


func get_from_pool_or_spawn(fx_id: String) -> Node3D:
	var asset_to_spawn = fx_descriptor_dico.get(fx_id);
	if (!spawned_fx.has(fx_id)):
		if (asset_to_spawn == null):
			return null;

		var new_pool_fx_array: Array[pool_fx];
		var new_pool_fx = pool_fx.new();
		new_pool_fx.spawned_fx = asset_to_spawn.instantiate();
		new_pool_fx_array.append(new_pool_fx);
		add_child(new_pool_fx.spawned_fx);

		spawned_fx[fx_id] = new_pool_fx_array;
		return new_pool_fx.spawned_fx;

	var fx_pool: Array[pool_fx] = spawned_fx.get(fx_id);

	for i in range(0, fx_pool.size()):
		var pool_fx_object = fx_pool[i];
		var fx = pool_fx_object.spawned_fx.get_node("particle");
		if (!fx.emitting):
			return pool_fx_object.spawned_fx;
		pass

	var instantiate_pool_fx = pool_fx.new();
	instantiate_pool_fx.spawned_fx = asset_to_spawn.instantiate();
	fx_pool.append(instantiate_pool_fx);
	add_child(instantiate_pool_fx.spawned_fx);

	return instantiate_pool_fx.spawned_fx;

# Called when the node enters the scene tree for the first time.
func request_fx(fx_id: String, spawn_position: Vector3) -> Node:
	var fx_to_spawn = get_from_pool_or_spawn(fx_id);
	if (fx_to_spawn == null):
		return

	fx_to_spawn.position = spawn_position;
	fx_to_spawn.scale = Vector3.ONE
	var particle = fx_to_spawn.get_node("particle");
	particle.restart()
	particle.emitting = true;
	return particle;

func request_attach_fx(fx_id: String, spawn_position: Vector3, parent : Node3D) -> Node:
	var fx_to_spawn = get_from_pool_or_spawn(fx_id);
	if (fx_to_spawn == null):
		return

	fx_to_spawn.position = spawn_position;
	fx_to_spawn.scale = Vector3.ONE
	var particle = fx_to_spawn.get_node("particle");
	particle.restart()
	particle.emitting = true;
	reparent_node(fx_to_spawn, parent)
	return fx_to_spawn;

func reparent_node(child: Node3D, new_parent: Node3D):
	var old_transform = child.global_transform
	child.get_parent().remove_child(child)
	new_parent.add_child(child)
	child.global_transform = old_transform
