extends Node

const x_color = Color.red
const y_color = Color.green

var debug_enabled = false
var space_state: Physics2DDirectSpaceState
var mouse_position = Vector2.ZERO
var camera_position = Vector2.ZERO

onready var debug2D_node := $DebugNode
onready var debug_ui := $CanvasLayer/DebugUI
onready var info_label_coordinates := $CanvasLayer/DebugUI/VBoxContainer/Coordinates
onready var info_label_obj_name := $CanvasLayer/DebugUI/VBoxContainer/ObjectName

func _ready() -> void:
	set_process(debug_enabled)
	set_physics_process(debug_enabled)
	set_process_input(debug_enabled)
	debug_ui.visible = debug_enabled

func _process(_delta: float) -> void:
	mouse_position = debug2D_node.get_global_mouse_position()
	debug2D_node.update()


func _physics_process(_delta: float) -> void:
	space_state = debug2D_node.get_world_2d().direct_space_state
	
	if Input.is_action_just_pressed("mouse_left_click"):
		_get_selected_object()


func _get_selected_object():
	var result = space_state.intersect_point(mouse_position)
	if result:
		info_label_obj_name.text = "Name: "+String(result[0].collider.name)
		info_label_coordinates.text = "Coord: "+String(result[0].collider.get_global_transform_with_canvas())
		if result[0].collider is TileMap:
			var _pos = result[0].collider.world_to_map(mouse_position)
			var _w_pos = result[0].collider.map_to_world(_pos)



func _on_DebugNode_draw() -> void:
	if not debug_enabled:
		return
	var _mouse_x_line = Vector2(mouse_position.x + 10, mouse_position.y)
	var _mouse_y_line = Vector2(mouse_position.x, mouse_position.y + 10)
	
	if Input.is_mouse_button_pressed(1):
		debug2D_node.draw_circle(mouse_position, 3.0, Color.black)
		debug2D_node.draw_circle(mouse_position, 2.0, Color.white)
	
	debug2D_node.draw_line(mouse_position, _mouse_x_line, x_color)
	debug2D_node.draw_line(mouse_position, _mouse_y_line, y_color)
