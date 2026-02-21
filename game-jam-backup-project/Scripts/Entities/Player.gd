extends Node3D

@onready var camera: Camera3D = $Camera3D
@export var move_speed: float = 10.0
@export var zoom_speed: float = 2.0
@export var min_zoom: float = 5.0
@export var max_zoom: float = 20.0
@export var zoom_smoothing: float = 8.0

# cam limits. Maybe they should be based on the world?????
@export var limit_left: float = -10.0
@export var limit_right: float = 10.0
@export var limit_forward: float = -10.0  
@export var limit_back: float = 10.0      

var target_zoom: float = 10.0
var velocity: Vector3 = Vector3.ZERO

@onready var ambiance_player: AudioStreamPlayer = $AmbiancePlayer

func _ready():
	camera.position.y = target_zoom
	ambiance_player.play()
	if	ResourceManagerSingleton:
		ResourceManagerSingleton.add_resource(ResourceType.RESOURCE_ID.LIVING_SPACE, 1)
	
	
func _process(delta):
	var input_dir : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_velocity : Vector3  = Vector3(input_dir.x, 0, input_dir.y) * move_speed
	velocity = velocity.lerp(target_velocity, delta * 10.0)
	
	var new_position : Vector3 = position + velocity * delta
	new_position.x = clamp(new_position.x, limit_left, limit_right)
	new_position.z = clamp(new_position.z, limit_forward, limit_back)
	position = new_position
	
	if (position.x <= limit_left and velocity.x < 0) or (position.x >= limit_right and velocity.x > 0):
		velocity.x = 0
	if (position.z <= limit_forward and velocity.z < 0) or (position.z >= limit_back and velocity.z > 0):
		velocity.z = 0
	
	camera.position.y = lerp(camera.position.y, target_zoom, zoom_smoothing * delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = clamp(target_zoom - zoom_speed, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = clamp(target_zoom + zoom_speed, min_zoom, max_zoom)
		 
func apply_position_limits(delta):
	var new_position : Vector3 = position + velocity * delta
	new_position.x = clamp(new_position.x, limit_left, limit_right)
	new_position.z = clamp(new_position.z, limit_forward, limit_back)
	position = new_position
	
