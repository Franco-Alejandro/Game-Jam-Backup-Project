extends Node3D
class_name PenguinBrain

enum PenguinState { IDLE, RUNNING_TO_TASK, DOING_TASK }
var _current_state : PenguinState = PenguinState.IDLE;

var behaviour : Dictionary = {
	PenguinState.IDLE: idle,
	PenguinState.RUNNING_TO_TASK: running_to_task,
	PenguinState.DOING_TASK: do_task
}
var task_duration_left : float = 0
var penguin_data : PenguinResource = PenguinResource.new() 

func _ready():
	add_to_group("penguins")
	
func _process(delta: float) -> void:
	if behaviour.get(_current_state) != null:
		behaviour[_current_state].call(delta)

func set_state(new_state: PenguinState):
	print("Penguin went to ", PenguinState.keys()[new_state])
	_current_state = new_state

func set_task(task: TaskResource):
	#ignore same tasks
	if penguin_data.current_task and penguin_data.current_task == task:
		return
	
	penguin_data.current_task = task
	set_state(PenguinState.RUNNING_TO_TASK)
	task_duration_left = task.duration

func idle(_delta: float):
	pass
	
func running_to_task(_delta: float):
	if penguin_data.current_task == null:
		set_state(PenguinState.IDLE)
		return;
	
	if penguin_data.current_task.location == Vector3.ZERO:
		set_state(PenguinState.DOING_TASK)
		
	print("Penguin is running to ", penguin_data.current_task.task_name)
	pass
	
func do_task(delta: float):
	task_duration_left -= delta
	
	if int(task_duration_left + delta) > int(task_duration_left):
		print("Penguin is doing ", penguin_data.current_task.task_name)
		print("time left", task_duration_left, " of ", penguin_data.current_task.duration)
	
	if (task_duration_left <= 0):
		task_duration_left = 0
		penguin_data.current_task = null
		set_state(PenguinState.IDLE)
		
	pass
