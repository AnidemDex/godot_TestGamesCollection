tool
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

const TILE = {
	"pared_izquierda": 1,
	"esquina": 2,
	"suelo": 3,
	"pared_derecha": 4,
	"base_esquina": 6,
	"caja": 7,
	}

var size = Vector2.ZERO
var start_point = Vector2.ZERO
var open_simplex_noise

onready var _tilemap : TileMap = $Enviorment
onready var reference_size = $ReferenceSize

func _ready():
	randomize()
	_tilemap.clear()
	open_simplex_noise = OpenSimplexNoise.new()
	open_simplex_noise.seed = randi()
	
	open_simplex_noise.octaves = 2
	open_simplex_noise.period = 15
	open_simplex_noise.lacunarity = 20
	open_simplex_noise.persistence = 0.75
	
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
	for x in range(start_point.x+1, size.x):
		for y in size.y-1:
			_tilemap.set_cell(x, y, _get_tile_index(open_simplex_noise.get_noise_2d(float(x), float(y))) )
	pass

func _get_tile_index(noise_sample) -> int:
	if noise_sample < -0.1:
		return TILE.suelo
	if noise_sample < 0.4:
		return 0
	return TILE.caja
