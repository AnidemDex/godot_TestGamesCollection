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
func _ready() -> void:
	
	look_at(pointer.position)
	direction = pointer.position - position
	speed = direction.x / 2.0


func _process(delta: float) -> void:
	position = position + (direction.normalized()*(speed*delta))
	pass

func destroy(score):
	var text = ""
	var color = Color("ffffff")
	
	$Node2D/Tween.interpolate_property($Circle32x32, "modulate", null, Color.transparent, 0.4)
	$Node2D/Tween.interpolate_property($Circle32x32, "position.x", null, -speed, 1.0)
	$Node2D/Tween.start()
	
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
			text = "Miss"
			color = Color(255,0,0)
	
	$Node2D/Label.text = text
	$Node2D/Label.modulate = color

	$Timer.start()


func _on_Timer_timeout() -> void:
	queue_free()
