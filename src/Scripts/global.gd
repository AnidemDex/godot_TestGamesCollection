tool
extends Node
# Script creado para el manejo global de variables
# y cambios de escenas.

enum SceneName {
	MAIN_MENU,
	CIRCLE_EVADER,
	RHYTHM_HERO_MAINMENU,
	RHYTHM_HERO_1,
	RHYTHM_HERO_2,
	}

enum GameState {
	PLAYING,
	LOADING,
	}

const SCENES = [
	"res://src/scenes/UI/MainMenu.tscn",
	"res://src/CircleEvader/Worlds/CircleEvaderWorld.tscn",
	"res://src/rhythm_hero/scenes/RhythmHeroMenu.tscn",
	"res://src/rhythm_hero/worlds/RhythmHeroWorld.tscn",
	"res://src/rhythm_hero/worlds/RhythmHeroWorld_2.tscn",
	]

var resource: ResourceQueue = preload("res://src/Scripts/resource_queue.gd").new()
var current_scene
var current_world = null
var current_game_state = GameState.PLAYING
var _loading_world = null
var _is_background_loading = false
onready var world_scene = get_node_or_null("/root/Main/WorldScene")


func _ready():
	resource.start()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)


func _process(_delta: float) -> void:
	if current_game_state == GameState.LOADING:
		update_loadScreen()
		
		if not _is_background_loading:
			_set_new_current_world()
			set_process(false)
		
		if resource.is_ready(_loading_world):
			_set_new_current_world()
			set_process(false)


func update_loadScreen():
	# Aqui se puede añadir una actualización de pantalla
	pass


func change_world(_scene, background_load: bool = false):
	#
	print("Cambiando a: ", _scene)
	world_scene.visible = false
	
	_loading_world = _scene
	_is_background_loading = background_load
	
	if _is_background_loading:
		resource.queue_resource(_loading_world)
	
	if current_world != null:
		_remove_current_world()
	
	current_game_state = GameState.LOADING


func _remove_current_world():
	world_scene.remove_child(current_world)
	current_world.call_deferred("free")
	current_world = null
	
	set_process(true)


func _set_new_current_world():

	var new_world = resource.get_resource(_loading_world)
	
	if new_world:
		current_world = new_world.instance()
		world_scene.add_child(current_world)
		world_scene.visible = true
		current_game_state = GameState.PLAYING
