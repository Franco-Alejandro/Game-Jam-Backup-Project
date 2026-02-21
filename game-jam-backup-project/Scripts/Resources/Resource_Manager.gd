extends Node

class_name ResourceManager

# in case we want other systems to react to it?
signal resource_changed(type: ResourceType, new_amount: int)

var resources: Dictionary = {}

func add_resource(type: ResourceType, amount: int):
	if not resources.has(type):
		resources[type] = 0
	
	resources[type] += amount
	resource_changed.emit(type, resources[type])

func get_resource(type: ResourceType) -> int:
	return resources.get(type, 0)

func _can_afford(type: ResourceType, amount: int) -> bool:
	return get_resource(type) >= amount

func spend_resource(type: ResourceType, amount: int) -> bool:
	if not _can_afford(type, amount):
		printerr("Not enough " + str(type.id) + " for this action.")
		return false
	
	resources[type] -= amount
	resource_changed.emit(type, resources[type])
	return true
