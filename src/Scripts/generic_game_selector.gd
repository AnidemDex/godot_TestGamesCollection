tool
extends Control

signal next_button_pressed

export(Texture) var icon:Texture setget set_icon
export(Color) var color:Color setget set_background_color
export(String) var title:String setget set_title


func set_icon(new_icon):
	icon = new_icon
	if not is_inside_tree() || not Engine.editor_hint:
		return
		
	$GameIcon.texture = icon
	property_list_changed_notify()


func set_background_color(new_color):
	color = new_color
	
	if not is_inside_tree() || not Engine.editor_hint:
		return
	
	$MenuBackground.modulate = color
	$MenuBackgroundBottom.modulate = color
	property_list_changed_notify()


func set_title(new_title):
	title = new_title
	
	$GameTitle.set_title(title)



func _on_NextGameButton_pressed():
	emit_signal("next_button_pressed")
