extends CanvasLayer
class_name HUDController


func _on_task_button_pressed() -> void:
	var focused_button : TaskButton = get_viewport().gui_get_focus_owner()
	if !focused_button:
		return;
		
	var penguins := get_tree().get_nodes_in_group("penguins");
	var penguin : PenguinBrain = penguins.pick_random()
	
	penguin.set_task(focused_button.task)
