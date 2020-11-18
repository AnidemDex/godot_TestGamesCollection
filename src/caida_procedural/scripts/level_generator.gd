
extends Node2D

enum Tile {
	EMPTY,
	LEFT_LIMIT,
	CORNER,
	FLOOR,
	WALL,
	RIGHT_LIMIT,
}

export(float, 1, 100, 0.1) var floor_probability: float = 50
export var start_point : Vector2 = Vector2.ZERO
export var end_point : Vector2 = Vector2(9,64)
export(OpenSimplexNoise) var simple_noise

var directions = [
	Vector2(1,0), Vector2(1,1), Vector2(0,1), 
	Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1), 
	Vector2(1,-1), Vector2(-1,1)]

onready var solid_enviorment: TileMap = $SolidEnviorment

func _ready() -> void:
	randomize()
	_check_simple_noise()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("key_c"):
		_smooth_map()
		
	if Input.is_action_just_pressed("key_z"):
		_make_map()


func _clean_map():
	solid_enviorment.clear()


func _make_map():
	_clean_map()
	# Generar elementos externos
	_make_outbounds()
	# Generar elementos internos
	_make_inbounds()
	


func _make_inbounds():
	for x in range(start_point.x+1, end_point.x):
		for y in range(start_point.y+6, end_point.y):
			var num = rand_range(0.0, 100.0)
			if num < floor_probability:
				solid_enviorment.set_cell(x, y, Tile.EMPTY)
	solid_enviorment.update_bitmask_region(Vector2.ZERO, end_point)


func _make_outbounds():
	for y in range(start_point.y, end_point.y):
		solid_enviorment.set_cell(start_point.x, y, Tile.LEFT_LIMIT)
		solid_enviorment.set_cell(end_point.x, y, Tile.RIGHT_LIMIT)


func _smooth_map():
	for x in range(start_point.x+1, end_point.x):
		for y in range(start_point.y, end_point.y):
			var neighbor_walls = 0
			for direction in directions:
				var current_tile = Vector2(x, y) + direction
				if (
					solid_enviorment.get_cell(current_tile.x,current_tile.y) == Tile.EMPTY ||
					solid_enviorment.get_cell(current_tile.x,current_tile.y) == Tile.LEFT_LIMIT ||
					solid_enviorment.get_cell(current_tile.x,current_tile.y) == Tile.RIGHT_LIMIT
					):
						neighbor_walls += 1
			
			if neighbor_walls > 4:
				solid_enviorment.set_cell(x, y, Tile.EMPTY)
	solid_enviorment.update_bitmask_region(Vector2.ZERO, end_point)


func _check_simple_noise():
	if simple_noise == null:
		simple_noise = OpenSimplexNoise.new()
#		simple_noise.octaves = 1.0
#		simple_noise.period = 12
#		simple_noise.persistence = 0.7
	simple_noise.seed = randi()
