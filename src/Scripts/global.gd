"""
Script creado para el manejo global de variables
y cambios de escenas.
"""

extends Node

var current_scene

var resource:ResourceQueue = preload("res://src/Scripts/resource_queue.gd").new()

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
"""
