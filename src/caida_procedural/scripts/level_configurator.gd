extends Node2D

var level_is_ready = false

func _ready() -> void:
	$LevelGenerator.make_map()
	pass


func on_LevelGenerator_started():
	pass


func on_LevelGenerator_finished():
	level_is_ready = true
	$PlayerStartPoint.create_player()
