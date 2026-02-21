extends Resource
class_name PenguinResource 



@export var penguin_name: String
@export var cozyness: int
@export var max_cozyness: int = 100
@export var max_speed: float = 30
@export var job: JobResource
@export var sprite_frames: SpriteFrames 

# ----------------- not needed now -----------------
@export var unique_traits: Array[String]
# ----------------- not needed now -----------------

# Set at runtime by hud controller
var current_task: TaskResource
