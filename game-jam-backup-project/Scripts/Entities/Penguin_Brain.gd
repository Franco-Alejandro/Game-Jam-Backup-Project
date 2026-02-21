extends CharacterBody3D
class_name PenguinBrain

@export var play_task_resource: TaskResource = preload("res://Resources/Tasks/play_task.tres")

enum PenguinState { IDLE, SELECT_LOCATION, RUNNING_TO_TASK, DOING_TASK }
var _current_state : PenguinState = PenguinState.IDLE;

var colony : Colony;

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

#Cozyness
var cozyness_regen_timer: float = 0
@export var cozyness_regen_interval: float = 5.0  
@export var cozyness_regen_amount: int = 1
# audio shit
@export var footstep_audio_player: AudioStreamPlayer3D 
@export var footstep_sounds: Array[AudioStream] 
@export var footstep_interval: float = 0.5  
var footstep_timer: float = 0

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
	penguin_data.cozyness = 3
	add_to_group("penguins")
	anim_tree = find_animation_tree(self)
	
func _process(delta: float) -> void:
	cozyness_regen_timer += delta
	if cozyness_regen_timer >= cozyness_regen_interval:
		regenerate_cozyness()
		cozyness_regen_timer = 0
		
	if behaviour.get(_current_state) != null:
		behaviour[_current_state].call(delta)

func regenerate_cozyness():
	if penguin_data:
		var new_cozyness = min(penguin_data.cozyness + cozyness_regen_amount, penguin_data.max_cozyness)
		if new_cozyness != penguin_data.cozyness:
			penguin_data.cozyness = new_cozyness
	
func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
		
	if _current_state == PenguinState.RUNNING_TO_TASK and is_on_floor():
		footstep_timer += delta
		if footstep_timer >= footstep_interval:
			play_footstep()
			footstep_timer = 0
	else:
		footstep_timer = 0  # Reset when not moving

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
	
func reset_animation_state():
	anim_tree["parameters/conditions/is_moving"] = false
	anim_tree["parameters/conditions/is_idle"] = false
	for flag_path in task_type_to_anim_flag.values():
		anim_tree[flag_path] = false
	
	
func update_animation_state():
	match _current_state:
		PenguinState.IDLE:
			anim_tree["parameters/conditions/is_idle"] = true
		PenguinState.RUNNING_TO_TASK:
			anim_tree["parameters/conditions/is_moving"] = true
		PenguinState.DOING_TASK:
			if penguin_data.current_task:
				anim_tree[task_type_to_anim_flag.get(penguin_data.current_task.task_type)] = true

func is_building_accesible(building: Building) -> bool:
	if !building.building_resource.unlocks_tasks.has(penguin_data.current_task):
		return false;
	
	if building.is_being_used:
		return false;
	
	return true

func set_task(task: TaskResource):
	# can't pay for the task
	if penguin_data.cozyness <= task.cozyness_cost:
		force_play_task()
		return
		
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
	if penguin_data.cozyness < penguin_data.max_cozyness * 0.3:  # Below 30%
		force_play_task()
	
func select_location(_delta: float):
	if penguin_data.current_task == null:
		set_state(PenguinState.IDLE)
		return;
	
	 #play tasks just pick a random nearby location instead of going to a building
	if penguin_data.current_task.task_type == TaskResource.TASK_TYPE.PLAY_AROUND:
		var random_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
		var random_distance = randf_range(5, 15)
		var play_location = global_position + random_direction * random_distance
		target_position(play_location)
		set_state(PenguinState.RUNNING_TO_TASK)
		return
	
	if target_building == null:
		return;
	
	target_position(target_building.global_position);
	
	set_state(PenguinState.RUNNING_TO_TASK)
	
func do_task(delta: float):
	task_duration_left -= delta
	
	if int(task_duration_left + delta) > int(task_duration_left):
		print("Penguin is doing ", penguin_data.current_task.task_name)
	
	if (task_duration_left <= 0):
		finish_task()
		

func move_to(position_to_go_to : Vector3):
	target_position(position_to_go_to);
	set_state(PenguinState.RUNNING_TO_TASK)
	

func finish_task():
	if penguin_data.current_task:
		var task = penguin_data.current_task
		if task.task_type == TaskResource.TASK_TYPE.PLAY_AROUND:
			penguin_data.cozyness += task.cozyness_reward
			penguin_data.cozyness = min(penguin_data.cozyness, penguin_data.max_cozyness)
		else:
			var resource_manager := ResourceManagerSingleton
			if resource_manager:
				for resource_id in task.rewards:
					var amount: int = task.rewards[resource_id]
					resource_manager.add_resource(resource_id, amount)
		penguin_data.cozyness -= penguin_data.current_task.cozyness_cost
		penguin_data.current_task = null
	task_duration_left = 0
	if target_building:
		target_building.is_being_used = false
		target_building = null

	set_state(PenguinState.IDLE)

func force_play_task():
	if play_task_resource:
		penguin_data.current_task = play_task_resource
		task_duration_left = play_task_resource.duration
		target_building = null
		set_state(PenguinState.SELECT_LOCATION)
		print("Penguin is too tired! Forced to play to regain cozyness.")
	else:
		print("No play task available!")
		
func print_animation_flags():
	print("---- Animation Flags ----")
	print("is_moving: ", anim_tree["parameters/conditions/is_moving"])
	print("is_idle: ", anim_tree["parameters/conditions/is_idle"])
	for task_type in task_type_to_anim_flag:
		var path = task_type_to_anim_flag[task_type]
		print(path, ": ", anim_tree[path])
	print("-------------------------")

func play_footstep():
	if footstep_audio_player and footstep_sounds.size() > 0:
		var random_index = randi() % footstep_sounds.size()
		footstep_audio_player.stream = footstep_sounds[random_index]
		footstep_audio_player.play()
