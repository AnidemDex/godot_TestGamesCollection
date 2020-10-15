extends Control

signal load_world(scene)


func _on_MenuItemContainer_button_pressed(world) -> void:
	print("Señal recibida: "+GLOBAL.SCENES[world])
	emit_signal("load_world", GLOBAL.SCENES[world])
