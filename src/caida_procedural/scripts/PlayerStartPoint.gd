extends Position2D

var player = preload("res://src/caida_procedural/actors/player.tscn")
var old_gravity

func create_player():
	var p:Node = player.instance()
	add_child(p)
	$ShakeCamera2D.target = p.get_path()
	$ShakeCamera2D.limit_bottom = CP_PLAYERDATA.LevelProperties.camera_limit
	
	old_gravity = p.gravity

func pause_player_gravity():
	var player = get_node("Player")
	player.gravity = 0
	player.actual_speed.y = 0
	pass

func resume_player_gravity():
	var player = get_node("Player")
	player.gravity = old_gravity
