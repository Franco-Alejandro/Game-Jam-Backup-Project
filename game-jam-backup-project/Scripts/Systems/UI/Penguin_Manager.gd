extends Control
class_name PenguinManager
@onready var penguin_name_edit : TextEdit = $MarginContainer/VBoxContainer/HBoxContainer/PenguinName
@onready var apply_button : Button = $MarginContainer/VBoxContainer/ApplyButton
var penguin : PenguinBrain;

func _ready():
	apply_button.hide()
	penguin_name_edit.text_changed.connect(_on_penguin_name_edit_text_changed.bind())

func populate_penguin(new_penguin : PenguinBrain):
	penguin = new_penguin
	penguin_name_edit.text = penguin.penguin_data.penguin_name

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


func _on_penguin_name_edit_text_changed() -> void:
	apply_button.show()

func _on_apply_button_pressed() -> void:
	penguin.penguin_data.penguin_name = penguin_name_edit.text
	hide()

func _on_hidden() -> void:
	apply_button.hide()
