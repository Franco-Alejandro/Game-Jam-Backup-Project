extends Resource
class_name NarrativeStepResource

# this is ewww but it is the way to do it in scripting
@export var step_id: String 

@export var title: String
@export var dialogue: String

@export var required_tasks_completed: Array[TaskResource]
@export var required_resources: Dictionary
@export var required_buildings: Array[BuildingResource]

@export var rewards: Dictionary

@export var next_step: NarrativeStepResource

@export var is_final: bool = false
