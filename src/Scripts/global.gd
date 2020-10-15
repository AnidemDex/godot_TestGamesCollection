"""
Script creado para el manejo global de variables
y cambios de escenas.
"""

extends Node

enum SCENE_NAME {
	MAIN_MENU,
	CIRCLE_EVADER,
	}

const SCENES = [
	"res://src/scenes/UI/MainMenu.tscn",
	"res://src/CircleEvader/Worlds/CircleEvaderWorld.tscn"
	]

enum LOAD_STATES {
	PLAYING,
	LOADING
	}

onready var world_scene = get_node("/root/Main/WorldScene")
var resource:ResourceQueue = preload("res://src/Scripts/resource_queue.gd").new()
var current_scene
var current_world = null


func _ready():
	resource.start()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
"""
Precarga -> Carga -> Poscarga
Precarga: prepara la escena a cargar
Carga: espera a que la escena este cargada
poscarga: devuelve la escena y limpia

TODO: Cambiar los estados del juego para actualizar la barra de carga
"""
func change_world(_scene):
	world_scene.visible = false
	
	if current_world != null:
		_remove_current_world()
	
	_set_new_current_world(_scene)

func _remove_current_world():
	world_scene.remove_child(current_world)
	current_world.call_deferred("free")
	current_world = null

func _set_new_current_world(_scene):
	current_world = resource.get_resource(_scene).instance()
	world_scene.add_child(current_world)
	world_scene.visible = true
	pass
