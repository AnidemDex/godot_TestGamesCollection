extends Node

var player_scene = preload("res://src/CircleEvader/Actors/Player.tscn")
var enemy_scene = preload("res://src/CircleEvader/Actors/Enemy.tscn")
var puntaje = 0

func _ready() -> void:
	randomize()
	

func new_game():
	puntaje = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$HUD.update_score(puntaje)
	$HUD.show_message("¡Cuidado!")
	$StartTimer.start()

func game_over():
	$EnemySpawnTimer.stop()
	$ScoreTimer.stop()
	$HUD.show_game_over()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().call_group("enemies", "queue_free")

func _on_StartTimer_timeout() -> void:
	var _player = player_scene.instance()
	_player.connect("hit", self, "game_over")
	$PlayerSpawnPoint.add_child(_player)
	$ScoreTimer.start()
	$EnemySpawnTimer.set_wait_time(0.5)
	$EnemySpawnTimer.start()


func _on_EnemySpawnTimer_timeout() -> void:
	$Path2D/PathFollow2D.offset = randi()
	var _enemy = enemy_scene.instance()
	add_child(_enemy)
	_enemy.position = $Path2D/PathFollow2D.position
	$EnemySpawnTimer.set_wait_time($EnemySpawnTimer.wait_time-0.0025)
	$EnemySpawnTimer.wait_time = clamp($EnemySpawnTimer.wait_time, 0.1, 1)
	
	


func _on_ScoreTimer_timeout() -> void:
	puntaje += 1
	$HUD.update_score(puntaje)
