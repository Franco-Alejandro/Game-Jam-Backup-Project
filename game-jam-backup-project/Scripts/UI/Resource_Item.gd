extends HBoxContainer

@export var resource_type: ResourceType

var resource_manager

@onready var icon_rect: TextureRect = $Icon
@onready var amount_label: Label = $Label


func _ready():
	resource_manager = get_tree().get_first_node_in_group("resource_manager")
	
	if resource_type:
		icon_rect.texture = resource_type.icon

	if resource_manager:
		resource_manager.resource_changed.connect(_on_resource_changed)
		update_display()

func _on_resource_changed(type: ResourceType, new_amount: int):
	if type == resource_type:
		amount_label.text = str(new_amount)

func update_display():
	if resource_manager and resource_type:
		amount_label.text = str(resource_manager.get_resource(resource_type))
