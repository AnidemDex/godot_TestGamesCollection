extends Control

func _on_MenuItemContainer_button_pressed(world) -> void:
	GLOBAL.change_world(GLOBAL.Scenes[world])
