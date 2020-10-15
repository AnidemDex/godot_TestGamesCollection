tool
extends MarginContainer

signal button_pressed

export(String) onready var title  = "Titulo" setget set_button_title
export(String, MULTILINE) var description = "Una descripción hilarante" setget set_description
export(GLOBAL.SCENE_NAME) var world = GLOBAL.SCENE_NAME.MAIN_MENU

var is_ready = false

func _ready() -> void:
	title = $VBoxContainer/Button.text
	property_list_changed_notify()
	description = $VBoxContainer/Label.text
	property_list_changed_notify()
	

func set_button_title(new_title: String) -> void:
	$VBoxContainer/Button.text = new_title
	property_list_changed_notify()

func set_description(new_description: String) -> void:
	$VBoxContainer/Label.text = new_description
	property_list_changed_notify()



func _on_Button_pressed() -> void:
	print("Boton presionado: "+str(world))
	emit_signal("button_pressed", world)
