extends Node3D
class_name Spawner

@export var penguin_scene: PackedScene
@export var spawn_interval: float = 5.0
@export var spawn_radius: float = 10.0

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
	# TODO: Add real resource logic later
	return true
