extends Control
class_name PenguinSelectionHUD

signal penguin_selected(penguin: PenguinBrain)
signal cancelled()

@export var penguin_manager_scene: PackedScene  
var penguin_manager : PenguinManager;

func _ready():
	var cancelButton : Button = $MarginContainer/HBoxContainer/CancelButton;
	cancelButton.pressed.connect(_on_cancel_pressed)
	show_penguins()

func show_penguins():
	var penguins = get_tree().get_nodes_in_group("penguins")
	var container = $MarginContainer/HBoxContainer/PenguinContainer 
	
	for child in container.get_children():
		child.queue_free()
	
	for penguin : PenguinBrain in penguins:
		var button = Button.new()
		button.text = penguin.penguin_data.penguin_name  
		button.pressed.connect(_on_penguin_button_pressed.bind(penguin))
		container.add_child(button)

func _on_penguin_button_pressed(penguin: PenguinBrain):
	penguin_selected.emit(penguin)

	
func _on_cancel_pressed():
	penguin_manager.hide()
