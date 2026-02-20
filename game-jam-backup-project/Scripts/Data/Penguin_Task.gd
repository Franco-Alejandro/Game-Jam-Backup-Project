extends Resource
class_name TaskResource

@export var task_name: String
@export var description: String
@export var duration: float  # Time to complete
@export var cozyness_cost: int
@export var rewards: Dictionary = {
	"fish": 0,
	"pebbles": 0,
	"ice_cream": 0
}
@export var location : Vector3 = Vector3.ZERO;
@export var required_job: JobResource
@export var animation_name: String
