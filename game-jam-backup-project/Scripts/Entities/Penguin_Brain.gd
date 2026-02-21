extends CharacterBody3D
class_name PenguinBrain

enum PenguinState { IDLE, SELECT_LOCATION, RUNNING_TO_TASK, DOING_TASK }
var _current_state : PenguinState = PenguinState.IDLE;

var colony : Colony;
static var stopping_distance: float = 0.5

static var task_type_to_anim_flag: Dictionary[TaskResource.TASK_TYPE, String] = {
	TaskResource.TASK_TYPE.GATHER_ICE_CREAM: "parameters/conditions/is_task_icecream",
	TaskResource.TASK_TYPE.GATHER_PEBBLES: "parameters/conditions/is_task_pebbles",
	TaskResource.TASK_TYPE.GATHER_FISH: "parameters/conditions/is_task_fish",
	TaskResource.TASK_TYPE.PLAY_AROUND: "parameters/conditions/is_task_play"
}
var behaviour : Dictionary = {
	PenguinState.IDLE: idle,
	PenguinState.SELECT_LOCATION: select_location,
	PenguinState.DOING_TASK: do_task
}
var task_duration_left : float = 0
var penguin_data : PenguinResource = PenguinResource.new() 
var target_building : Building;

# DEBUG STUFF
@onready var nav = $NavigationAgent3D
var speed = 3.5;
var gravity = 9.8;

var anim_tree: AnimationTree

func find_animation_tree(node: Node) -> AnimationTree:
	for child in node.get_children():
		if child is AnimationTree:
			return child
		var result = find_animation_tree(child)
		if result:
			return result
	return null
	
func _ready():
	penguin_data.penguin_name = "Juan"
	add_to_group("penguins")
	anim_tree = find_animation_tree(self)
	
func _process(delta: float) -> void:
	if behaviour.get(_current_state) != null:
		behaviour[_current_state].call(delta)
	
func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	# Check if we reached the location
	if nav.is_navigation_finished():
		if _current_state == PenguinState.RUNNING_TO_TASK:
			set_state(PenguinState.DOING_TASK)
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return

	# Navigation
	var next_position = nav.get_next_path_position()
	var current_position = global_transform.origin
	
	var direction = next_position - current_position
	direction.y = 0
	
	if direction.length() > 0.1:
		# Rotation
		look_at(global_position - direction, Vector3.UP)
		
		direction = direction.normalized()
		var horizontal_velocity = direction * speed
		
		velocity.x = horizontal_velocity.x
		velocity.z = horizontal_velocity.z
	else:
		velocity.x = 0
		velocity.z = 0

	# Actual movement
	move_and_slide()

func target_position(target):
	nav.target_position = target

func set_state(new_state: PenguinState):
	print("Penguin went to ", PenguinState.keys()[new_state])
	reset_animation_state()
	_current_state = new_state
	update_animation_state()
	print_animation_flags()
	
func reset_animation_state():
	anim_tree["parameters/conditions/is_moving"] = false
	anim_tree["parameters/conditions/is_idle"] = false
	# Turn all task flags off
	for flag_path in task_type_to_anim_flag.values():
		anim_tree[flag_path] = false
	
	
func update_animation_state():
	match _current_state:
		PenguinState.IDLE:
			anim_tree["parameters/conditions/is_idle"] = true
		PenguinState.RUNNING_TO_TASK:
			anim_tree["parameters/conditions/is_moving"] = true
		PenguinState.DOING_TASK:
			anim_tree[task_type_to_anim_flag.get(penguin_data.current_task.task_type)] = true

func is_building_accesible(building: Building) -> bool:
	if !building.building_resource.unlocks_tasks.has(penguin_data.current_task):
		return false;
	
	if building.is_being_used:
		return false;
	
	return true

func set_task(task: TaskResource):
	var bebe = get_tree().get_nodes_in_group("Colony")
	colony = get_tree().get_nodes_in_group("Colony").pick_random()
	
	if !colony:
		return;
	#ignore same tasks
	if penguin_data.current_task and penguin_data.current_task == task:
		return
	penguin_data.current_task = task
	
	var available_buildings : Array[Building] = colony.get_built_buildings();
	var building_index : int = available_buildings.find_custom(is_building_accesible.bind())
	if building_index < 0:
		penguin_data.current_task = null
		set_state(PenguinState.IDLE)
		return
		
	target_building = available_buildings.get(building_index);
	if not target_building:
		return;
		
	target_building.is_being_used = true;
	set_state(PenguinState.SELECT_LOCATION)
	task_duration_left = task.duration

func idle(_delta: float):
	pass
	
func select_location(delta: float):
	if penguin_data.current_task == null:
		set_state(PenguinState.IDLE)
		return;
	
	if target_building == null:
		return;
	
	target_position(target_building.global_position);
	
	set_state(PenguinState.RUNNING_TO_TASK)
	
func do_task(delta: float):
	task_duration_left -= delta
	
	if int(task_duration_left + delta) > int(task_duration_left):
		print("Penguin is doing ", penguin_data.current_task.task_name)
		print("time left ", int(task_duration_left), " of ", penguin_data.current_task.duration)
	
	if (task_duration_left <= 0):
		finish_task()
		
	
func finish_task():
	var resource_manager := ResourceManagerSingleton
	if resource_manager:
		for resource_id in penguin_data.current_task.rewards:
			var amount: int = penguin_data.current_task.rewards[resource_id]
			resource_manager.add_resource(resource_id, amount)
	task_duration_left = 0
	penguin_data.current_task = null
	target_building.is_being_used = false
	target_building = null
	set_state(PenguinState.IDLE)
	
	
func print_animation_flags():
	print("---- Animation Flags ----")
	print("is_moving: ", anim_tree["parameters/conditions/is_moving"])
	print("is_idle: ", anim_tree["parameters/conditions/is_idle"])
	for task_type in task_type_to_anim_flag:
		var path = task_type_to_anim_flag[task_type]
		print(path, ": ", anim_tree[path])
	print("-------------------------")
