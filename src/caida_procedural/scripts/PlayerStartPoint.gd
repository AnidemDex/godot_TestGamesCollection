extends Position2D

var player = preload("res://src/caida_procedural/actors/player.tscn")
var old_gravity
var player_node : Node

func create_player():
	player_node = player.instance()
	add_child(player_node)
	$ShakeCamera2D.target = player_node.get_path()
	$ShakeCamera2D.limit_bottom = CP_PLAYERDATA.LevelProperties.camera_limit
	
	player_node = get_node("Player")
	player_node.connect("bullet_generated", self, "on_Player_bullet_generated")
	
	old_gravity = player_node.gravity

func pause_player_gravity():
	player_node.gravity = 0
	player_node.actual_speed.y = 0

func resume_player_gravity():
	player_node.gravity = old_gravity

func on_Player_bullet_generated():
	$ShakeCamera2D.add_trauma(0.1)
