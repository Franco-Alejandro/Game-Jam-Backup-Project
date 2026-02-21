extends Node3D
class_name Spawner

@export var penguin_scene: PackedScene
@export var spawn_interval: float = 5.0
@export var spawn_radius: float = 10.0
@export var names_database: PenguinNames  

var used_names: Array[String] = []
var _spawned_penguins: Array = []

func _ready():
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.timeout.connect(try_spawn)
	timer.autostart = true
	add_child(timer)
	
func try_spawn():
	if _spawned_penguins.size() >= ResourceManagerSingleton.get_resource(ResourceType.RESOURCE_ID.LIVING_SPACE):
		return
	
	if not can_spawn():
		return
	
	spawn_penguin()
	
func spawn_penguin():
	var penguin = penguin_scene.instantiate()
	get_parent().add_child(penguin)
	
	penguin.global_position = global_position
	penguin.penguin_data.penguin_name = get_unique_name()

	var random_offset = Vector3(
		randf_range(-spawn_radius, spawn_radius),
		0,
		randf_range(-spawn_radius, spawn_radius)
	)
	
	var target_position : Vector3 = global_position + random_offset
	
	if penguin.has_method("move_to"):
		penguin.move_to(target_position)
	
	_spawned_penguins.append(penguin)
	
func can_spawn() -> bool:
	# TODO: Add real resource logic later fish?
	return true

func get_unique_name() -> String:
	var available_names = get_available_names()
	if available_names.size() > 0:
		var random_index = randi() % available_names.size()
		var new_name = available_names[random_index]
		used_names.append(new_name)
		return new_name
	else:
		# we made too many, add a number
		return "Penguin " + str(_spawned_penguins.size() + 1)

func get_available_names() -> Array[String]:
	var all_names: Array[String] = []
	if names_database:
		for first in names_database.first_names:
			for last in names_database.last_names:
				var full_name = first + " " + last
				if full_name not in used_names:
					all_names.append(full_name)
	
	return all_names
