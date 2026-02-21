extends CanvasLayer
class_name HUDController

@export var penguin_selection_hud_scene: PackedScene  
@export var penguin_manager_scene: PackedScene  
var penguin_selection_HUD : PenguinSelectionHUD;
var penguin_manager : PenguinManager;
		
func _on_penguin_selected(penguin: PenguinBrain) -> void:
	if !penguin_manager:
		penguin_manager = penguin_manager_scene.instantiate()
		add_child(penguin_manager) 
	else:
		penguin_manager.show()
	if penguin_selection_HUD:
		penguin_selection_HUD.hide()
		
	penguin_manager.populate_penguin(penguin);
	
func _on_penguin_hud_button_pressed() -> void:
	if !penguin_selection_HUD:
		penguin_selection_HUD = penguin_selection_hud_scene.instantiate()
		penguin_selection_HUD.penguin_selected.connect(_on_penguin_selected)
		add_child(penguin_selection_HUD) 
	else:
		penguin_selection_HUD.show()
