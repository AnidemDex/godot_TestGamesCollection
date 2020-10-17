extends Node2D

enum NoteValue {
	NONE,
	PERFECT, 
	GOOD, 
	NICE, 
	BAD,
	}

var speed = 0
var direction = Vector2.ZERO
onready var pointer: Node2D = get_node("../EnemyPointer")
onready var tween = $Node2D/Tween
onready var timer = $Timer

func _ready() -> void:
	
	look_at(pointer.position)
	direction = pointer.position - position
	speed = direction.x / 1



func _process(delta: float) -> void:
	position = position + (direction.normalized()*(speed*delta))
	pass

func destroy(score):
	var text = ""
	var color = Color("ffffff")
	
	tween.interpolate_property($Circle32x32, "modulate", null, Color.transparent, 0.4)
	tween.interpolate_property($Circle32x32, "position", Vector2(10.0,0.0), Vector2(-speed, 0.0), 1.0)
	tween.interpolate_property($Node2D/Label, "rect_position", null, Vector2(0.0,-30), 1.0)
	tween.start()
	
	speed = 0
	
	match score:
		NoteValue.PERFECT:
			text = "PERFECT!"
			color = Color("f6d6bd")
			
		NoteValue.GOOD:
			text = "Good!"
			color = Color("c3a38a")
			
		NoteValue.NICE:
			text = "Nice"
			color = Color("997577")

		NoteValue.BAD:
			text = "Bad"
			color = Color(255,0,0)
		
		_:
			text = "MISSED!"
			color = Color.gray
	
	$Node2D/Label.text = text
	$Node2D/Label.modulate = color

	timer.start()


func _on_Timer_timeout() -> void:
	queue_free()
