extends Node3D
class_name Colony

var layers: Array[ColonyLayer]
var current_level: int = -1

func get_buildable_buildings() -> Array[Building]:
	var unbuilt_buildings: Array[Building]
	
	for layer in layers:
		for building in layer.buildings:
			if not building.built:
				unbuilt_buildings.append(building)
				
	return unbuilt_buildings
	
func get_built_buildings() -> Array[Building]:
	var built_buildings: Array[Building]
	
	for layer in layers:
		for building in layer.buildings:
			if building.built:
				built_buildings.append(building)
				
	return built_buildings

func upgrade() -> void:
	if current_level >= layers.size() - 1:
		return
	
	current_level += 1
	layers[current_level].activate_layer()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var upgradeIndex: int = 1

	while has_node(str("UpgradeLayer", upgradeIndex)):
		var layerNode: Node = get_node(str("UpgradeLayer", upgradeIndex))
		var layer: ColonyLayer = ColonyLayer.new()
		
		for child in layerNode.get_children():
			if child is Building:
				layer.buildings.append(child)
		
		layers.append(layer)
		upgradeIndex += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("upgrade_cheat"):
		upgrade()
