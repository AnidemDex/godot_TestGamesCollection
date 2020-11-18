extends Node2D

onready var player = preload("res://src/caida_procedural/actors/player.tscn")

func _ready() -> void:
	$LevelGenerator.make_map()
	pass


func on_LevelGenerator_started():
	pass


func on_LevelGenerator_finished():
	var p:Node = player.instance()
	$PlayerStartPoint.add_child(p)
	$PlayerStartPoint/ShakeCamera2D.target = p.get_path()
