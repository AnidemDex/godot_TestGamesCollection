extends Node


enum LoadStates {
	TRANSITION_IN,
	LOADING,
	TRANSITION_OUT,
	PLAYING
}

var loading_world = null
var current_world : Node = null
var game_state = LoadStates.PLAYING

func _ready() -> void:
	load_world(GLOBAL.SCENE["CircleEvader"])

func load_world(scene) -> void:
	loading_world = scene
	GLOBAL.resource.queue_resource(loading_world, true)
	game_state = LoadStates.TRANSITION_IN
	$UI/LoadingScreen.transition.play("FadeIn")

func _process(delta: float) -> void:
	if game_state == LoadStates.LOADING:
		update_loadscreen()
		if GLOBAL.resource.is_ready(loading_world):
			goto_new_world()
			set_process(false)

func update_loadscreen() -> void:
	var progress = GLOBAL.resource.get_progress(loading_world)*100
	$UI/LoadingScreen.update_bar(progress)

func goto_new_world() -> void:
	var new_world = GLOBAL.resource.get_resource(loading_world)
	
	if new_world:
		current_world = new_world.instance()
		$WorldScene.add_child(current_world)
		
		connect("ready", self, "_on_current_world_ready")

func _on_current_world_ready():
	game_state = LoadStates.TRANSITION_OUT

func _on_LoadingScreen_finished_animation() -> void:
	match game_state:
		LoadStates.TRANSITION_IN:
			$WorldScene.set_visible(false)
			
			if current_world:
				$WorldScene.remove_child(current_world)
				# current_world.disconnect("load_world", self, "load_world")
				current_world.queue_free()
				current_world = null
			
			game_state = LoadStates.LOADING
			set_process(true)
		
		LoadStates.TRANSITION_OUT:
			# current_world.connect("load_world", self, "load_world")
			$WorldScene.set_visible(true)
			$UI/LoadingScreen.set_visible(false)
			
			game_state = LoadStates.PLAYING
		_:
			pass
