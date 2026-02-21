extends HBoxContainer

@onready var amount_label: Label = $Label
@onready var icon_rect: TextureRect = $Icon

@export var resource_id: ResourceType.RESOURCE_ID
@export var resource_data: ResourceType

var resource_manager

func _ready():
	resource_manager = ResourceManagerSingleton
	
	if resource_data:
		icon_rect.texture = resource_data.icon
	
	if resource_manager:
		resource_manager.resource_changed.connect(_on_resource_changed)
		update_display()

func _on_resource_changed(changed_id: ResourceType.RESOURCE_ID, new_amount: int):
	if changed_id == resource_id:
		amount_label.text = str(new_amount)

func update_display():
	if resource_manager:
		amount_label.text = str(
			resource_manager.get_resource(resource_id)
		)
