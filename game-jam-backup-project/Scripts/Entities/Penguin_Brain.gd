extends CharacterBody3D
class_name PenguinBrain

enum PenguinState { IDLE, SELECT_LOCATION, RUNNING_TO_TASK, DOING_TASK }
var _current_state : PenguinState = PenguinState.IDLE;
var is_idle : bool = true;
var is_moving : bool = false;

var colony : Colony;
static var stopping_distance: float = 0.5

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

func _ready():
	penguin_data.penguin_name = "Juan"
	add_to_group("penguins")
	
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
	_current_state = new_state
	match _current_state:
		PenguinState.IDLE:
			is_moving = false
			is_idle = true;
		PenguinState.RUNNING_TO_TASK:
			is_moving = true
			is_idle = false;

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
	#if distance > stopping_distance:
	#	direction = direction.normalized()
	#else:
	#	set_state(PenguinState.DOING_TASK)
		
func do_task(delta: float):
	task_duration_left -= delta
	
	if int(task_duration_left + delta) > int(task_duration_left):
		print("Penguin is doing ", penguin_data.current_task.task_name)
		print("time left", task_duration_left, " of ", penguin_data.current_task.duration)
	
	if (task_duration_left <= 0):
		task_duration_left = 0
		penguin_data.current_task = null
		target_building.is_being_used = false
		target_building = null
		penguin_data.current_task = null
		set_state(PenguinState.IDLE)
		
	pass
