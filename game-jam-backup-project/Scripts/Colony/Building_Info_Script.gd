extends Node3D
class_name BuildingInfo

@onready var label: Label3D = $Label
var building: Building

func set_building(associated_building: Building) -> void:
	building = associated_building
	label.text = ""
	var resource: BuildingResource = building.building_resource
	
	label.text += resource.building_name + "\n\n"
	label.text += resource.description + "\n\n"
	
	for key: ResourceType.RESOURCE_ID in resource.required_resources:
		label.text += ResourceType.RESOURCE_ID.keys()[key] + ": " + str(resource.required_resources[key]) + "\n"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
