extends Node2D

var degree = 0

export(int) var radius = 2

var r

onready var base = $Base
onready var out_circle = $OutCircle
onready var in_circle = $InCircle
onready var collision = $Area2D/CollisionShape2D

func _ready() -> void:
	r = radius * 16
	
	var shape : CircleShape2D = CircleShape2D.new()
	shape.radius = r
	collision.shape = shape


func _process(_delta: float) -> void:
	if not Engine.editor_hint:
		degree = 0.01
		out_circle.rotate(-degree)
		in_circle.rotate(degree)

func _draw() -> void:
	base.update()
	out_circle.update()
	in_circle.update()
	pass


func _on_Base_draw() -> void:
	base.draw_circle(Vector2.ZERO, r, Color("1a1a1a"))
	pass


func _on_OutCircle_draw() -> void:
	out_circle.draw_arc(Vector2.ZERO, r+5, 0, 25, 60, Color.red, 2)
	


func _on_InCircle_draw() -> void:
	in_circle.draw_arc(Vector2.ZERO, r, 0, 25, 45, Color.red)


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		CP_PLAYERDATA.player_freeze_world = true



func _on_Area2D_body_exited(body: Node) -> void:
	if body.name == "Player":
		CP_PLAYERDATA.player_freeze_world = false

