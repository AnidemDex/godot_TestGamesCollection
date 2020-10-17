extends Node2D

var enemy = preload("res://src/rhythm_hero/actors/enemy_note.tscn")

func _ready():
	$Conductor.play_with_beat_offset(8)
	pass

func _input(event):
	if event.is_action_pressed("key_z"):
		generate_note()
		

func generate_note():
	var fast_enemy = enemy.instance()
	fast_enemy.position = $EnemySpawnerLeft.position
	add_child(fast_enemy)

func _on_Conductor_beat(position):
	print(position)


func _on_Conductor_measure(position):
	match position:
		_:
			generate_note()
	pass # Replace with function body.
