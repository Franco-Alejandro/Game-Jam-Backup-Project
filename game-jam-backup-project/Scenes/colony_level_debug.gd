extends Node3D

@onready var colony: Colony = $ColonyScene

func _ready() -> void:
	ResourceManagerSingleton.add_resource(ResourceType.RESOURCE_ID.FISH, 20)
	ResourceManagerSingleton.add_resource(ResourceType.RESOURCE_ID.ICE_CREAM, 20)
	ResourceManagerSingleton.add_resource(ResourceType.RESOURCE_ID.PEBBLE, 20)
	colony.upgrade();
	for building in colony.get_buildable_buildings():
		colony.try_to_build_building(building)
