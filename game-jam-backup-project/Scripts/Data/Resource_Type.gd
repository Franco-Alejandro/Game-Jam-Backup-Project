extends Resource
class_name ResourceType

enum RESOURCE_ID { FISH, ICE_CREAM, PEBBLE, LIVING_SPACE }

@export var id: RESOURCE_ID
@export var icon: Texture2D
@export var color: Color
@export var max_stack: int = 999
