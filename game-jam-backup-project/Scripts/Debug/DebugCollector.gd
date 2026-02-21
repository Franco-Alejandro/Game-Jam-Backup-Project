extends Node3D

@onready var label: Label3D = $Label3D
@onready var bar_fill: MeshInstance3D = $ProductionBar/BarFill

@export var resource_id: ResourceType.RESOURCE_ID
@export var production_interval: float = 5.0
@export var production_amount: int = 1

var resource_manager: ResourceManager
var progress: float = 0.0


func _ready():
	resource_manager = ResourceManagerSingleton
	
	if resource_id:
		label.text = str(resource_id).capitalize() + " Collector"

func _process(delta):
	progress += delta
	
	var ratio = clamp(progress / production_interval, 0.0, 1.0)
	bar_fill.scale.x = ratio
	
	if progress >= production_interval:
		progress = 0.0
		bar_fill.scale.x = 0.0
		
		resource_manager.add_resource(resource_id, production_amount)
