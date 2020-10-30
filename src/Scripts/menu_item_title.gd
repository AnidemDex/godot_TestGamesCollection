tool
extends Control

export(String) var title = "----Titulo----" setget set_title
var offset = Vector2(32,32)

func _ready():
	if title != null:
		$Title.set_text(title)
		property_list_changed_notify()
	rect_size = $Title.rect_size+offset


func _process(_delta):
	if Engine.editor_hint:
		rect_size = $Title.rect_size+offset

func set_title(new_title):
	title = new_title
	property_list_changed_notify()
	
	if not is_inside_tree() || not Engine.editor_hint:
		return
	
	if title != null:
		$Title.set_text(title)
		property_list_changed_notify()
	
	rect_size = $Title.rect_size+offset
	property_list_changed_notify()
	pass
