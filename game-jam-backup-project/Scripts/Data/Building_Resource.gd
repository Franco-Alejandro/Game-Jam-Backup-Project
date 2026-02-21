extends Resource
class_name BuildingResource 

@export var building_name: String
@export var description: String
@export var required_resources: Dictionary[ResourceType.RESOURCE_ID, int] = {
	ResourceType.RESOURCE_ID.FISH: 0,
	ResourceType.RESOURCE_ID.PEBBLE: 0,
	ResourceType.RESOURCE_ID.ICE_CREAM: 0
}
@export var unlocks_tasks: Array[TaskResource]
@export var unlocks_jobs: Array[JobResource]
@export var building_scene: PackedScene 
@export var provided_living_space: int

# maybe it is like an entertainment building?
@export var cozyness_generation_per_second: int = 0  
