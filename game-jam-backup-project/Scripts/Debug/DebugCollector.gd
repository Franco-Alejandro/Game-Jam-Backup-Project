extends Node3D

@onready var label: Label3D = $Label3D
@onready var bar_fill: MeshInstance3D = $ProductionBar/BarFill

@export var type: ResourceType
@export var production_interval: float = 5.0
@export var production_amount: int = 1

var resource_manager: ResourceManager
var progress: float = 0.0


func _ready():
	resource_manager = ResourceManagerSingleton
	
	if type:
		label.text = str(type.id).capitalize() + " Collector"


func _process(delta):
	if not type or not resource_manager:
		return
	
	# Progress növelése
	progress += delta
	
	var ratio = clamp(progress / production_interval, 0.0, 1.0)
	bar_fill.scale.x = ratio
	
	# Ha betelt
	if progress >= production_interval:
		progress = 0.0
		bar_fill.scale.x = 0.0
		
		resource_manager.add_resource(type, production_amount)
