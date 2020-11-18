extends Position2D

signal bullet_generated

export var bullet_impulse = 10

onready var bullet = preload("res://src/caida_procedural/actors/bullet.tscn")

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("key_z") or event.is_action_pressed("key_c"):
		if(not owner.is_on_floor()):
			var new_bullet: Node2D = bullet.instance()
			add_child(new_bullet)
			emit_signal("bullet_generated")
