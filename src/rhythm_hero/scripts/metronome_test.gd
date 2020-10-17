extends Sprite

func _ready() -> void:
	# get_node("../Conductor").play()
	pass


func _on_Conductor_beat(_position) -> void:
	pass




func _on_Conductor_measure(position) -> void:
	scale = Vector2(1,1) if (position % 2) == 0 else Vector2(1.5,1.5)
	pass
