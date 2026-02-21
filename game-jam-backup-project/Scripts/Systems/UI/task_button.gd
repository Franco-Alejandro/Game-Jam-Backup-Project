extends Button
class_name TaskContainerButton

@export var task : TaskResource

func _ready():
	if task:
		tooltip_text = task.description
