extends VBoxContainer

func _process(delta: float) -> void:
	$Label2.text = String(CP_PLAYERDATA.level_number)
