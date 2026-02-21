extends Button
class_name TaskContainerButton

@export var task : TaskResource

func _ready():
	tooltip_text = task.description
