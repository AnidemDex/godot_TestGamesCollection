extends TileMap


func change_world():
	CP_PLAYERDATA.bullets = 0
	GLOBAL.change_world(GLOBAL.SCENES[GLOBAL.SceneName.CAIDA_PROCEDURAL_BETWEEN_LEVEL])

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		get_tree().create_timer(1).connect("timeout",self, "change_world")

