extends Node2D

signal destroyed(score_value)

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
onready var tween = $Tween
onready var timer = $Timer

func _ready() -> void:
	direction = pointer.position - position
	speed = direction.x / 2



func _process(delta: float) -> void:
	position = position + (direction.normalized()*(speed*delta)) if speed > 0 else position + Vector2(speed*delta,0.0)
	pass

func destroy(score):
	var text = ""
	var color = Color("ffffff")
	
	tween.interpolate_property($Circle32x32, "modulate", null, Color.transparent, 0.2)
	tween.interpolate_property($Circle32x32, "position", Vector2(10.0,0.0), Vector2(-speed, 0.0), 1.0)
	tween.interpolate_property($Node2D/Label, "rect_position", null, Vector2(0.0,-30), 1.0)
	tween.start()
	
	speed = 0
	
	match score:
		NoteValue.PERFECT:
			text = "PERFECT!"
			color = Color("f6d6bd")
			emit_signal("destroyed", NoteValue.PERFECT)
			
		NoteValue.GOOD:
			text = "Good!"
			color = Color("c3a38a")
			emit_signal("destroyed", NoteValue.GOOD)
			
		NoteValue.NICE:
			text = "Nice"
			color = Color("997577")
			emit_signal("destroyed", NoteValue.NICE)

		NoteValue.BAD:
			text = "Bad"
			color = Color(255,0,0)
			emit_signal("destroyed", NoteValue.BAD)
		
		_:
			text = "MISSED!"
			color = Color.gray
			emit_signal("destroyed", NoteValue.NONE)
	
	$Node2D/Label.text = text
	$Node2D/Label.modulate = color

	timer.start()


func _on_Timer_timeout() -> void:
	queue_free()
