extends Control

func _on_GameInfoPanel_change_world_request(world) -> void:
	GLOBAL.change_world(GLOBAL.SCENES[world])
