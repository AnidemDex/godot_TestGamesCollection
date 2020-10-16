extends Area2D
signal hit
var mouse_position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position= event.position

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if mouse_position != null:
		global_position = mouse_position
	pass


func _on_Player_body_entered(_body: Node) -> void:
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.
