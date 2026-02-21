extends Control
class_name PenguinManager
@onready var penguin_name : Label = $MarginContainer/VBoxContainer/HBoxContainer/PenguinName

var penguin : PenguinBrain;

func _ready():
	pass;

func populate_penguin(new_penguin : PenguinBrain):
	penguin = new_penguin
	penguin_name.text = penguin.penguin_data.penguin_name

func _on_cancel_button_pressed() -> void:
	hide()

func get_focused_task() -> TaskResource:
	var focused_button : TaskContainerButton = get_viewport().gui_get_focus_owner()
	if !focused_button:
		return;
	
	return focused_button.task
	
func _on_fish_button_pressed() -> void:
	penguin.set_task(get_focused_task())
	hide()


func _on_ice_cream_button_pressed() -> void:
	penguin.set_task(get_focused_task())
	hide()


func _on_pebble_button_pressed() -> void:
	penguin.set_task(get_focused_task())
	hide()
