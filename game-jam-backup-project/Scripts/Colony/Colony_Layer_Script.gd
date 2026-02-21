extends Node
class_name ColonyLayer

var buildings: Array[Building]
var props: Array[Node]
var active: bool = false

func activate_layer() -> void:
	for building in buildings:
		building.activate()
		
	for prop in props:
		prop.show()
		
	active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
