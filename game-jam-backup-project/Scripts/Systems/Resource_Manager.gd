extends Node
class_name ResourceManager

signal resource_changed(id: ResourceType.RESOURCE_ID, new_amount: int)

var resources: Dictionary = {}

func _ready():
	for id in ResourceType.RESOURCE_ID.values():
		resources[id] = 999

func add_resource(id: ResourceType.RESOURCE_ID, amount: int):
	resources[id] += amount
	resource_changed.emit(id, resources[id])

func get_resource(id: ResourceType.RESOURCE_ID) -> int:
	return resources.get(id, 0)

func can_afford(id: ResourceType.RESOURCE_ID, amount: int) -> bool:
	return get_resource(id) >= amount

func spend_resource(id: ResourceType.RESOURCE_ID, amount: int) -> bool:
	if not can_afford(id, amount):
		printerr("Not enough resource: ", ResourceType.RESOURCE_ID.keys()[id])
		return false
	
	resources[id] -= amount
	resource_changed.emit(id, resources[id])
	return true
