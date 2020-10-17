extends Node2D


func _ready() -> void:
	pass


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("music_notes"):
		area.queue_free()
	pass # Replace with function body.
