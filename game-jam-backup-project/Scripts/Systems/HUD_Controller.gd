extends CanvasLayer
class_name HUDController

@export var penguin_selection_hud_scene: PackedScene  

func _on_penguin_hud_button_pressed() -> void:
	var hud : PenguinSelectionHUD = penguin_selection_hud_scene.instantiate()
	hud.cancelled.connect(_on_selection_cancelled)
	add_child(hud)  # Add to current scene

	pass # Replace with function body.

func _on_selection_cancelled():
	print("Penguin selection cancelled")
