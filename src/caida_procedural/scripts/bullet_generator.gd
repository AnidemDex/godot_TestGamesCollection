extends Position2D

signal bullet_generated

onready var bullet = preload("res://src/caida_procedural/actors/bullet.tscn")

func _process(_delta: float) -> void:
	update()
	
func _draw() -> void:
	pass
	
	

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("key_z") or event.is_action_pressed("key_c"):
		if owner._bullets > 0:
			var new_bullet: Node2D = bullet.instance()
			add_child(new_bullet)
			emit_signal("bullet_generated")
