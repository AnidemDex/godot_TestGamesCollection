tool
extends MarginContainer

signal button_pressed

export(String) var title = null setget set_button_title
export(String, MULTILINE) var description = null setget set_description

export(GLOBAL.SceneName) var world = GLOBAL.SceneName.MAIN_MENU

var is_ready = false

func _ready():
	
	$VBoxContainer/Button.text = title
	$VBoxContainer/Label.text = description

func _process(_delta):
	if Engine.editor_hint:
		$VBoxContainer/Button.text = str(title)
		$VBoxContainer/Label.text = str(description)
	
func set_button_title(new_title: String) -> void:
	title = new_title
	property_list_changed_notify()
	if not is_inside_tree():
		return
	$VBoxContainer/Button.text = new_title

func set_description(new_description: String) -> void:
	description = new_description
	property_list_changed_notify()
	if not is_inside_tree():
		return
	$VBoxContainer/Label.text = new_description
	



func _on_Button_pressed() -> void:
	emit_signal("button_pressed", world)
