@tool
extends Node3D
class_name Building

var active: bool = false
var built: bool = false
var is_being_used: bool = false

@export var building_resource: BuildingResource
@export var building_base: PackedScene
var building_scene: Node = null
var scaffolding_scene: Node = null
var resource_manager: ResourceManager

# Activates the building when the layer becomes active, does not build it
func activate() -> void:
	active = true
	show()
	
	if building_resource != null and building_resource.building_scene != null:
		building_scene = building_resource.building_scene.instantiate()
		building_scene.hide()
		building_scene.set_process(false)
		add_child(building_scene)
	else:
		printerr("Building has no building resource or building scene in the resource!")
		
	if not Engine.is_editor_hint():
		if building_resource != null and building_resource.scaffolding_scene != null:
			scaffolding_scene = building_resource.scaffolding_scene.instantiate()
			add_child(scaffolding_scene)
		else:
			printerr("Building has no building resource or scaffolding scene in the resource!")
		
	
func build() -> void:
	if building_scene != null:
		building_scene.show()
		building_scene.set_process(true)
		built = true
		
		if scaffolding_scene != null:
			scaffolding_scene.queue_free()
		
		if not Engine.is_editor_hint():
			if building_resource.provided_living_space > 0:
				resource_manager.add_resource(ResourceType.RESOURCE_ID.LIVING_SPACE, building_resource.provided_living_space)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resource_manager = ResourceManagerSingleton

	if Engine.is_editor_hint():
		activate()
		build()
	else:
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if Input.is_action_just_pressed("build_cheat"):
		build()
