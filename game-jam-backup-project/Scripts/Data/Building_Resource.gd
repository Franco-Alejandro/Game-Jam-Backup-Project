extends Resource
class_name BuildingResource 

@export var building_name: String
@export var description: String
@export var required_resources: Dictionary = {
	"fish": 0,
	"pebbles": 0,
	"ice_cream": 0
}
@export var unlocks_tasks: Array[TaskResource]
@export var unlocks_jobs: Array[JobResource]
@export var building_scene: PackedScene 

# maybe it is like an entertainment building?
@export var cozyness_generation_per_second: int = 0  
