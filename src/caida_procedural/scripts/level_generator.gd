extends Node2D
class_name LevelGenerator

signal started
signal finished

enum Cell {
	DESTRUCTUBLE, 
	GROUND, 
	OUTER
	}

var _random_number = RandomNumberGenerator.new()
var size = Vector2.ZERO
var start_point = Vector2.ZERO

onready var _tilemap : TileMap = $Enviorment
onready var reference_size = $ReferenceSize

func _ready():
	_random_number.randomize()
	setup()
	print("start: ", start_point, " end: ", size)
	generate()

func setup():
	size = (reference_size.rect_size+reference_size.rect_global_position)/16
	size = Vector2(int(size.x), int(size.y))
	start_point = reference_size.rect_global_position/16
	start_point = Vector2(int(start_point.x), int(start_point.y))
	pass

func generate():
	emit_signal("started")
	_generate_perimeter()
	_generate_inner()
	emit_signal("finished")
	pass

func _generate_perimeter():
	for x in [start_point.x, size.x]:
		for y in range(0, size.y):
			_tilemap.set_cell(x, y, 3)

func _generate_inner():
	pass
