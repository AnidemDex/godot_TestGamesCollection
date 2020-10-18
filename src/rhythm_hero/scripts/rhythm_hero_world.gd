extends Node2D

var notes = {
	"Perfect": 0,
	"Good": 0,
	"Nice": 0,
	"Bad": 0,
	"Miss": 0,
}

var enemy = preload("res://src/rhythm_hero/actors/enemy_note.tscn")
var combo = 0
var max_combo = 0
var score = 0
export var start_beat = 0
export var stop_beat = 208

onready var combo_label = $UI/Control/Combo
onready var max_combo_label = $UI/Control/MaxCombo
onready var perfect_score_label = $UI/CenterContainer/VBoxContainer/NotasP/Score
onready var good_score_label = $UI/CenterContainer/VBoxContainer/NotasG/Score
onready var nice_score_label = $UI/CenterContainer/VBoxContainer/NotasA/Score
onready var bad_score_label = $UI/CenterContainer/VBoxContainer/NotasM/Score
onready var miss_score_label = $UI/CenterContainer/VBoxContainer/NotasF/Score
onready var total_notes_label = $UI/CenterContainer/VBoxContainer/NotasTotal/Score
onready var total_score_label = $UI/CenterContainer/VBoxContainer/Puntos/Score
onready var score_container = $UI/CenterContainer

func _ready():
	randomize()
	$TimerToStart.start()
	combo_label.visible = false


func _input(_event):
	pass
		

func generate_note():
	var fast_enemy = enemy.instance()
	var position = randi() % 2
	fast_enemy.position = $EnemySpawnerLeft.position if position == 1 else $EnemySpawnerRight.position
	fast_enemy.connect("destroyed", self, "_on_note_destroyed")
	add_child(fast_enemy)


func show_end():
	yield(get_tree().create_timer(1.5), "timeout")
	$Tween.interpolate_property($UI/Control, "margin_top", null, 0, 1.0)
	$Tween.interpolate_property($UI/Control, "margin_bottom", null, 360-8, 1.0)
	combo_label.visible = false
	
	yield(get_tree().create_timer(1.2), "timeout")
	perfect_score_label.text = str(notes.Perfect)
	good_score_label.text = str(notes.Good)
	nice_score_label.text = str(notes.Nice)
	bad_score_label.text = str(notes.Bad)
	miss_score_label.text = str(notes.Miss)
	var total_notes = notes.Perfect + notes.Good + notes.Nice + notes.Miss + notes.Bad
	total_notes_label.text = str(total_notes)
	score = (((notes.Perfect*3)+(notes.Good*2)+(notes.Nice))-(notes.Bad*5))*max_combo
	total_score_label.text = str(score)
	score_container.visible = true
	$Tween.interpolate_property(score_container, "modulate", Color.transparent, Color.white, 1.0)
	$Tween.stop(score_container)
	
	Label
	
	pass


func _on_note_destroyed(value):
	var label_font = combo_label.get_font("font")
	
	if value > 0 and value <=3:
		combo += 10
	else:
		combo = 0
	
	if combo > max_combo:
		max_combo = combo
		max_combo_label.text = "x"+str(max_combo)
	
	if combo >= 20:
		combo_label.visible = true
	else:
		combo_label.visible = false
		label_font.size = 24
	
	if combo % 1000 == 0:
		$Tween.interpolate_property(label_font, "size", 140, 64, 0.4, Tween.TRANS_BOUNCE,Tween.EASE_OUT)
		combo_label.modulate = Color.darkgoldenrod
	elif combo % 100 == 0:
		$Tween.interpolate_property(label_font, "size", 128, 64, 0.4, Tween.TRANS_BOUNCE,Tween.EASE_OUT)
		combo_label.modulate = Color.blueviolet
	else:
		$Tween.interpolate_property(label_font, "size", 8, clamp(label_font.size+8, 12, 64), 0.2, Tween.TRANS_BOUNCE,Tween.EASE_OUT)
		combo_label.modulate = Color.blue
	
	combo_label.text = "x"+str(combo)
	
	
	match value:
		0:
			# Missed
			notes.Miss += 1
			
		1:
			# Perfect
			notes.Perfect += 1
			
		2:
			# Good
			notes.Good += 1
			
		3:
			# Nice
			notes.Nice += 1
			
		4:
			# Bad
			notes.Bad += 1
			

func _on_Conductor_beat(position):
	print(position)
	if position < stop_beat and position > start_beat:
		generate_note()
	elif position < stop_beat:
		return
	else:
		show_end()


func _on_Conductor_measure(position):
	match position:
		_:
			#print("[", position, "]")
			pass


func _on_TimerToStart_timeout():
	$Conductor.play()
	$Tween.interpolate_property($UI/Control/TextureRect, "margin_left", null, 0, $Conductor.stream.get_length())
	$Tween.interpolate_property($UI/Control/TextureRect, "margin_right", null, 0, $Conductor.stream.get_length())
	$Tween.start()
