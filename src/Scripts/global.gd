"""
Script creado para el manejo global de variables
y cambios de escenas.
"""

extends Node

var current_scene

var resource:ResourceQueue = preload("res://src/Scripts/resource_queue.gd").new()
const SCENE = {
	"MainScene": "",
	"CircleEvader": "res://src/CircleEvader/Worlds/CircleEvaderWorld.tscn"
	}

func _ready():
	resource.start()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
