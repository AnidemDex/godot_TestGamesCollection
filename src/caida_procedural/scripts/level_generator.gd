tool
extends Node2D

signal started
signal finished

enum Tile {
	EMPTY,
	LEFT_LIMIT,
	CORNER,
	FLOOR,
	WALL,
	RIGHT_LIMIT,
	BOX,
	NAVIGATION,
}

export(float, 1, 100, 0.1) var floor_probability: float = 18
export var start_point : Vector2 = Vector2.ZERO setget _set_start_point
export var end_point : Vector2 = Vector2(9,64) setget _set_end_point
export var smooth_times : int = 1

var box_methods = ["_single_box"]

#-1,-1[5]	0,-1[6]	1,-1[7]
#-1,0 [3]	0,0 [x]	1,0 [4]
#-1,1 [0]	0,1 [1]	1,1 [2]
var directions = [
	Vector2(-1,1), Vector2(0,1), Vector2(1,1), 
	Vector2(-1,0), Vector2(1,0), Vector2(-1,-1), 
	Vector2(0,-1), Vector2(1,-1)
	]

onready var solid_enviorment: TileMap = $Navigation2D/SolidEnviorment
onready var exit: TileMap = preload("res://src/caida_procedural/scenes/exit.tscn").instance()

func _ready() -> void:
	randomize()
	update()
	var _error_start = connect("started", owner, "on_LevelGenerator_started")
	var _error_finish = connect("finished", owner, "on_LevelGenerator_finished")


func _draw() -> void:
	# Dibuja dentro del editor los limites del nivel
	if Engine.editor_hint:
		var level_size:Rect2 = Rect2()
		level_size.position = start_point
		level_size.end = end_point * 16
		draw_rect(level_size, Color.red, false)


func make_map():
	emit_signal("started")
	
	var sucefully_map = _start_new_map()
	
	while sucefully_map != true:
		sucefully_map = _start_new_map()
	
	_finish_new_map()
	
	emit_signal("finished")


func _set_start_point(value):
	start_point = value
	update()


func _set_end_point(value):
	end_point = value
	update()


func _clean_map():
	solid_enviorment.clear()


func _start_new_map() -> bool:
	_clean_map()
	# Generar elementos externos
	_make_outbounds()
	# Generar elementos internos
	if _can_make_inbounds():
		return true
	else:
		return false


func _finish_new_map():
	# Crea salidas y mejora el aspecto visual de los muros
	_make_store()
	_make_exit()
	_clean_outbounds()


func _can_make_inbounds() -> bool:
	# Genera el suelo
	_generate_solids()
	# Suavizar terreno
	for _attemp in range(0, smooth_times):
		_smooth_map()
	# Elimina bloques flotantes
	_clean_solids()
	# Reorganiza el tile
	_set_tiles()
	# Crea el relleno de navegación
	if not _can_create_navigation():
		push_warning("Oops, mapa equivocado. Generando otro...")
		return false
	# Crea cajas destructibles
	_generate_boxes()
	return true


func _generate_solids():
	for x in range(start_point.x+1, end_point.x):
		for y in range(start_point.y+6, end_point.y):
			var num = rand_range(0.0, 100.0)
			if num < floor_probability:
				solid_enviorment.set_cell(x, y, Tile.EMPTY)
	
	solid_enviorment.update_bitmask_region(Vector2.ZERO, end_point)


func _clean_solids():
	# Esta aproximación requiere un poco de explicación
	# Verifico cada tile vecino en los ejes
	# Si la suma es mayor que 1, se conserva
	# El chiste es eliminar diagonales y bloques flotantes.
	
	for x in range(start_point.x+1, end_point.x):
		for y in range(start_point.y, end_point.y):
			var neighbor_tile = 0
			for direction in [directions[1],directions[3],directions[4],directions[6]]:
				var current_tile = Vector2(x,y)+direction
				
				if solid_enviorment.get_cell(current_tile.x,current_tile.y) == Tile.EMPTY:
					neighbor_tile += 1
			
			if neighbor_tile < 1:
				solid_enviorment.set_cell(x,y, -1)


func _set_tiles():
	for x in range(start_point.x+1, end_point.x):
		for y in range(start_point.y, end_point.y):
			if solid_enviorment.get_cell(x, y) != -1:
				_evaluate_cell(Vector2(x, y))


func _evaluate_cell(cell_coordinate):
	# Esta es larga de explicar en texto, refierete a la imagen del papel
	# Basicamente evaluamos las posibilidades y segun eso se da el tile
	
	var tile = Tile.EMPTY
	var flip_x = false
	var flip_y = false
	
	var neighbor_tile = 0
	for direction in [directions[1],directions[3],directions[4],directions[6]]:
		if solid_enviorment.get_cellv(cell_coordinate+direction) != -1:
			neighbor_tile += 1
	
	if neighbor_tile >= 4:
		tile = Tile.EMPTY
	
	# TOP
	var top_neighbor = solid_enviorment.get_cellv(cell_coordinate+directions[6])
	var left_neighbor = solid_enviorment.get_cellv(cell_coordinate+directions[3])
	var right_neighbor = solid_enviorment.get_cellv(cell_coordinate+directions[4])
	var bot_neighbor = solid_enviorment.get_cellv(cell_coordinate+directions[1])
	
	if top_neighbor == -1:
		tile = Tile.CORNER
		if left_neighbor == -1:
			flip_x = false
		elif right_neighbor == -1:
			flip_x = true
		
		if right_neighbor != -1 && left_neighbor != -1:
			tile = Tile.FLOOR
			flip_x = false
	else:
		tile = Tile.WALL
		flip_x = solid_enviorment.is_cell_x_flipped(
			(cell_coordinate.x+directions[6].x), 
			(cell_coordinate.y+directions[6].y))
		
		if left_neighbor != -1:
			flip_x = true
		
		if left_neighbor != -1 && right_neighbor != -1:
			tile = Tile.EMPTY
			flip_x = false
		
		if bot_neighbor == -1:
			tile = Tile.CORNER
			flip_y = true
			if left_neighbor == -1:
				flip_x = false
			elif right_neighbor == -1:
				flip_x = true
			
			if right_neighbor != -1 && left_neighbor != -1:
				tile = Tile.FLOOR
				flip_x = false
	
	
	solid_enviorment.set_cellv(cell_coordinate, tile, flip_x, flip_y)


func _make_outbounds():
	# Crea los limites laterales
	
	for y in range(start_point.y, end_point.y):
		solid_enviorment.set_cell(start_point.x, y, Tile.LEFT_LIMIT)
		solid_enviorment.set_cell(end_point.x, y, Tile.RIGHT_LIMIT)


func _make_exit():
	add_child(exit)
	exit.position = Vector2(0, solid_enviorment.map_to_world(end_point).y)


func _make_store():
	pass


func _clean_outbounds():
	# Verifica si las paredes limites tienen algun vecino
	# Si es asi, se vuelve un tile vacio
	
	for y in range(start_point.y, end_point.y):
		var left_neighbor = solid_enviorment.get_cellv(Vector2(end_point.x,y)+directions[3])
		var right_neighbor = solid_enviorment.get_cellv(Vector2(start_point.x,y)+directions[4])
		
		if left_neighbor != -1 and left_neighbor != Tile.BOX and left_neighbor != Tile.NAVIGATION:
			solid_enviorment.set_cell(end_point.x, y, Tile.EMPTY)
		if right_neighbor != -1 and right_neighbor != Tile.BOX and right_neighbor != Tile.NAVIGATION:
			solid_enviorment.set_cell(start_point.x, y, Tile.EMPTY)


func _smooth_map():
	var smooth_tiles = []
	
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
				smooth_tiles.append(Vector2(x,y))

	for coordinate in smooth_tiles:
		solid_enviorment.set_cellv(coordinate, Tile.EMPTY)

	solid_enviorment.update_bitmask_region(Vector2.ZERO, end_point)


func _can_create_navigation() -> bool:
	# Devuelve True si pudo crear un camino
	# False si no
	
	for x in range(start_point.x+1, end_point.x):
		for y in range(start_point.y, end_point.y):
			if solid_enviorment.get_cell(x,y) == -1:
				solid_enviorment.set_cell(x,y, Tile.NAVIGATION)
	
	solid_enviorment.update_dirty_quadrants()	
	
	var start = solid_enviorment.map_to_world(Vector2(int(end_point.x/2+1),1))
	var end = solid_enviorment.map_to_world(Vector2(int(end_point.x/2+1),end_point.y-1))
	var path: PoolVector2Array = $Navigation2D.get_simple_path(start, end)
	
	for x in range(start_point.x+1, end_point.x):
		for y in range(start_point.y, end_point.y):
			if solid_enviorment.get_cell(x,y) == Tile.NAVIGATION:
				solid_enviorment.set_cell(x,y, -1)
	
	if path.size() > 0:
		return true
	else:
		return false


func _generate_boxes():
	for x in range(start_point.x+1, end_point.x):
		for y in range(start_point.y+6, end_point.y):
			var num = rand_range(0.0, 100.0)
			if num < floor_probability:
				var selected_figure = randi() % box_methods.size()
				call(box_methods[selected_figure], Vector2(x,y))

func _single_box(cell_coordinate):
	var top_neighbor = solid_enviorment.get_cellv(cell_coordinate+directions[6])
	if solid_enviorment.get_cellv(cell_coordinate) == -1 && top_neighbor == -1:
		solid_enviorment.set_cellv(cell_coordinate, Tile.BOX)
