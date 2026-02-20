extends Button

@export var resource_type: ResourceType
@export var spend_amount: int = 5

var resource_manager

func _ready():
	resource_manager = get_tree().get_first_node_in_group("resource_manager")
	pressed.connect(_on_pressed)

func _on_pressed():
	if not resource_manager or not resource_type:
		return
	
	var success = resource_manager.spend_resource(resource_type, spend_amount)
	
	if success:
		print("Spent ", spend_amount, " ", resource_type.id)
