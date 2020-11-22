extends Node2D

var level_is_ready = false
onready var player = preload("res://src/caida_procedural/actors/player.tscn")

func _ready() -> void:
	$LevelGenerator.make_map()
	pass


func on_LevelGenerator_started():
	pass


func on_LevelGenerator_finished():
	level_is_ready = true
	var p:Node = player.instance()
	$PlayerStartPoint.add_child(p)
	$PlayerStartPoint/ShakeCamera2D.target = p.get_path()
