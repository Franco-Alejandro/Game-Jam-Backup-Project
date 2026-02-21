extends Control
class_name PenguinManager
@onready var cancel_button : Button = $MarginContainer/HBoxContainer/CancelButton;
@onready var penguin_name : Label = $MarginContainer/VBoxContainer/HBoxContainer/PenguinName

var penguin : PenguinBrain;

func _ready():
	pass;

func populate_penguin(new_penguin : PenguinBrain):
	penguin = new_penguin
	penguin_name.text = penguin.penguin_data.penguin_name

func _on_cancel_button_pressed() -> void:
	hide()
