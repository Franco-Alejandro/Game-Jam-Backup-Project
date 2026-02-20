extends Button
class_name TaskButton

@export var task : TaskResource

func _ready():
	tooltip_text = task.description
	
