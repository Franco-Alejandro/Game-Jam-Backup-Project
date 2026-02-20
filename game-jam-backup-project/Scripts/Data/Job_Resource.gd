extends Resource
class_name JobResource 

@export var job_name: String
@export var description: String
@export var available_tasks: Array[TaskResource]
@export var base_cozyness_cost_multiplier: float = 1.0
@export var icon: Texture2D 
