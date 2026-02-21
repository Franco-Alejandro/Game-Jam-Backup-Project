extends Node3D
class_name Colony

var layers: Array[ColonyLayer]
var current_level: int = -1
var buildingInfo: Node = null

func get_buildable_buildings() -> Array[Building]:
	var unbuilt_buildings: Array[Building]
	
	for layer in layers:
		if not layer.active:
			break
		
		for building in layer.buildings:
			if not building.built:
				unbuilt_buildings.append(building)
				
	return unbuilt_buildings
	
func get_built_buildings() -> Array[Building]:
	var built_buildings: Array[Building]
	
	for layer in layers:
		if not layer.active:
			break
			
		for building in layer.buildings:
			if building.built:
				built_buildings.append(building)
				
	return built_buildings

func upgrade() -> void:
	if current_level >= layers.size() - 1:
		return
	
	current_level += 1
	layers[current_level].activate_layer()
	
func try_to_build_building(building: Building) -> void:
	var resource : BuildingResource = building.building_resource
	
	for key: ResourceType.RESOURCE_ID in resource.required_resources:
		if not ResourceManagerSingleton.can_afford(key, resource.required_resources[key]):
			return
			
	for key: ResourceType.RESOURCE_ID in resource.required_resources:
		ResourceManagerSingleton.spend_resource(key, resource.required_resources[key])
	
	building.build()
	
func cast_ray() -> Dictionary:
	var space = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var start = get_viewport().get_camera_3d().project_ray_origin(mouse_pos)
	var end = get_viewport().get_camera_3d().project_position(mouse_pos, 10000000.0)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end
	params.collide_with_areas = true
	params.collide_with_bodies = true
	return space.intersect_ray(params)
	
func interact_with_uinbuilt_building(building: Building) -> void:
	if buildingInfo == null || buildingInfo.building != building:	
		if buildingInfo != null:
			buildingInfo.free()
		
		var infoScene = preload("res://Scenes/Colony/Building_Info_Scene.tscn")
		buildingInfo = infoScene.instantiate()
		building.add_child(buildingInfo)
		buildingInfo.set_building(building)
		buildingInfo.position.y += 2

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		try_to_build_building(building)
	
func interact() -> void:
	var result = cast_ray()
	
	if not result.is_empty() && result.collider is Building:
		var collider = result.collider
		
		for layer in layers:
			for building in layer.buildings:
				if collider == building && building.active && not building.built:
					interact_with_uinbuilt_building(building)
					return
			
	if buildingInfo != null:		
		buildingInfo.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var upgradeIndex: int = 1
	add_to_group("Colony")
	while has_node(str("UpgradeLayer", upgradeIndex)):
		var layerNode: Node = get_node(str("UpgradeLayer", upgradeIndex))
		var layer: ColonyLayer = ColonyLayer.new()
		
		for child in layerNode.get_children():
			if child is Building:
				layer.buildings.append(child)
		
		layers.append(layer)
		upgradeIndex += 1
		
	# TODO DEBUG STUFF DELET LATER HIT JOAKIM
	upgrade()
	for building in get_buildable_buildings():
		building.build()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("upgrade_cheat"):
		upgrade()
		
	interact()
