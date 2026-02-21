extends Resource
class_name TaskResource

enum TASK_TYPE { GATHER_ICE_CREAM, GATHER_PEBBLES, GATHER_FISH, PLAY_AROUND}

@export var task_type:TASK_TYPE
@export var task_name: String
@export var description: String
@export var duration: float
@export var cozyness_cost: int
@export var rewards: Dictionary = {
	"fish": 0,
	"pebbles": 0,
	"ice_cream": 0
}
