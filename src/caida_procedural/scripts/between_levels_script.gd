extends Node2D

var counter = 0

func _ready() -> void:
	$PlayerStartPoint.create_player()
	$Timer.start()


func go_to_level():
	CP_PLAYERDATA.go_to_level()


func _on_Timer_timeout() -> void:
	counter += 1
	if counter < 5:
		$PlayerStartPoint.pause_player_gravity()
	else:
		$PlayerStartPoint.resume_player_gravity()
	if counter == 7:
		go_to_level()
