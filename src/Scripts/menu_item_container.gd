tool
extends MarginContainer

signal button_pressed

export(String) var title  = "Titulo" setget set_button_title
export(String, MULTILINE) var description = "Una descripción hilarante" setget set_description

export(GLOBAL.SceneName) var world = GLOBAL.SceneName.MAIN_MENU

var is_ready = false


func set_button_title(new_title: String) -> void:
	$VBoxContainer/Button.text = new_title
	property_list_changed_notify()

func set_description(new_description: String) -> void:
	$VBoxContainer/Label.text = new_description
	property_list_changed_notify()



func _on_Button_pressed() -> void:
	emit_signal("button_pressed", world)
