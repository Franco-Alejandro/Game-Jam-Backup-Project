extends Node3D
class_name BuildingInfo

@onready var label: Label3D = $Label
var building: Building

func set_building(associated_building: Building) -> void:
	building = associated_building
	label.text = ""
	var resource: BuildingResource = building.building_resource
	
	for key in resource.required_resources:
		label.text += key + ": " + str(resource.required_resources[key]) + "\n"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
