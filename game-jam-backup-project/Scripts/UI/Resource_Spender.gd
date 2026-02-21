extends Button

@export var resource_id: ResourceType.RESOURCE_ID
@export var spend_amount: int = 5

var resource_manager

func _ready():
	resource_manager = ResourceManagerSingleton
	pressed.connect(_on_pressed)

func _on_pressed():
	if not resource_manager:
		return
	
	var success = resource_manager.spend_resource(resource_id, spend_amount)
	
	if success:
		print("Spent ", spend_amount, " ", _get_resource_name(resource_id))

func _get_resource_name(id: ResourceType.RESOURCE_ID) -> String:
	return ResourceType.RESOURCE_ID.keys()[id].capitalize()
