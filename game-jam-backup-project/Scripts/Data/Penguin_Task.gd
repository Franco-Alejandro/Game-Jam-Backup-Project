extends Resource
class_name TaskResource

enum TASK_TYPE { GATHER_ICE_CREAM, GATHER_PEBBLES, GATHER_FISH, PLAY_AROUND}

@export var task_type:TASK_TYPE
@export var task_name: String
@export var description: String
@export var duration: float
@export var cozyness_cost: int
@export var rewards: Dictionary[ResourceType.RESOURCE_ID, int] = {
	ResourceType.RESOURCE_ID.FISH: 0,
	ResourceType.RESOURCE_ID.ICE_CREAM: 0,
	ResourceType.RESOURCE_ID.PEBBLE: 0,
	ResourceType.RESOURCE_ID.LIVING_SPACE: 0,
}
