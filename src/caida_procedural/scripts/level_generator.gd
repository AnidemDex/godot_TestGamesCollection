extends Node2D
class_name LevelGenerator
# Reglas al generar
# 1. Debe tener paredes laterales X[0:11].
# 2. Debe tener una salida de 3 casillas.
#    a) La salida mide 2 casillas de alto
#    b) Las casillas laterales tienen estructura solida
#       hasta llegar a la pared solamente en la casilla
#       superior.

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
	# Generar las paredes laterales
	for y in range(0, size.y):
		_tilemap.set_cell(start_point.x, y, 1)
		_tilemap.set_cell(size.x, y, 4)
	
	# Generar salida
	for x in range(0, size.x):
		match x:
			3:
				_tilemap.set_cell(start_point.x+x, size.y, 5, true)
			6:
				_tilemap.set_cell(start_point.x+x, size.y, 5)
			_:
				_tilemap.set_cell(start_point.x+x, size.y, 0)
				
	_tilemap.set_cell(start_point.x+0, size.y-1, 0)
	_tilemap.set_cell(start_point.x+1, size.y-1, 3, true)
	_tilemap.set_cell(start_point.x+2, size.y-1, 3, true)
	_tilemap.set_cell(start_point.x+3, size.y-1, 2, true)
	
	_tilemap.set_cell(start_point.x+4, size.y-1, 0)
	_tilemap.set_cell(start_point.x+5, size.y-1, 0)
	
	_tilemap.set_cell(start_point.x+6, size.y-1, 2)
	_tilemap.set_cell(start_point.x+7, size.y-1, 3)
	_tilemap.set_cell(start_point.x+8, size.y-1, 3)
	_tilemap.set_cell(start_point.x+9, size.y-1, 0)
	

func _generate_inner():
	pass
