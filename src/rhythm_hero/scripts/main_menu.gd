extends Control

var is_on_button = false
var button = 0

onready var first_lvl_button = $CustomButton1/FirstLevenButton/Polygon2D
onready var second_lvl_button = $CustomButton2/SecondLevelButton/Polygon2D2
onready var mouse = $Mouse


func _ready():
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse.position = event.position

	if event is InputEventMouseButton:
		if event.button_index == 1 && is_on_button:
			var world_to_go = 0
			match button:
				1:
					world_to_go = GLOBAL.SCENES[GLOBAL.SceneName.RHYTHM_HERO_1]
				2:
					world_to_go = GLOBAL.SCENES[GLOBAL.SceneName.RHYTHM_HERO_2]
			GLOBAL.change_world(world_to_go)
	


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),
								linear2db(value))


func _on_Conductor_beat(_position):
	pass

func _on_FirstLevenButton_area_entered(area):
	first_lvl_button.color = first_lvl_button.color.darkened(0.5)
	is_on_button = true
	button = 1



func _on_FirstLevenButton_area_exited(area):
	first_lvl_button.color = first_lvl_button.color.darkened(-1)
	is_on_button = false
	button = 0


func _on_SecondLevelButton_area_entered(area):
	second_lvl_button.color = second_lvl_button.color.darkened(0.5)
	is_on_button = true
	button = 2


func _on_SecondLevelButton_area_exited(area):
	second_lvl_button.color = second_lvl_button.color.darkened(-1)
	is_on_button = false
	button = 0


func _on_Conductor_measure(position):
	match position:
		0:
			$Background/ColorRect.color.darkened(0.5)
		1:
			$Background/ColorRect.color.darkened(-1)

