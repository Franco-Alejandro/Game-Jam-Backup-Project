extends Node3D

@onready var label: Label3D = $Label3D

@export var type: ResourceType
@export var production_interval: float = 5.0
@export var production_amount: int = 1

var timer: Timer
var resource_manager: ResourceManager

func _ready():
	resource_manager = get_tree().get_first_node_in_group("resource_manager")
	
	if type:
		label.text = type.id + " collector"
	
	timer = Timer.new()
	timer.wait_time = production_interval
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout():
	if resource_manager:
		resource_manager.add_resource(type, production_amount)
