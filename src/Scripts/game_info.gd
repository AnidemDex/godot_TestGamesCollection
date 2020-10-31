extends Control

signal change_world_request(world)

var selected_game = null

onready var tween = $Tween
onready var panel = $Panel
onready var info_label = $Panel/WhitePanel/Label

func _ready() -> void:
	panel.rect_position.y = -141


func animate_in(game_info):
	selected_game = game_info
	_prepare_panel()
	
	tween.interpolate_property(panel, "rect_position:y", null, 0, 0.25, Tween.TRANS_QUART)
	tween.start()


func animate_out():
	tween.interpolate_property(panel, "rect_position:y", null, 282, 0.25, Tween.TRANS_QUART)
	tween.start()
	yield(tween, "tween_all_completed")
	panel.rect_position.y = -141
	info_label.text = ""


func _prepare_panel():
	if selected_game != null:
		match selected_game:
			0:
				info_label.text = GAMEMETADATA.CircleEvader.info
			1:
				info_label.text = GAMEMETADATA.RhythmHero.info
			2:
				info_label.text = GAMEMETADATA.CaidaProcedural.info


func _on_PlayButton_pressed() -> void:
	if selected_game != null:
		match selected_game:
			0:
				emit_signal(
					"change_world_request", 
					GLOBAL.SceneName.CIRCLE_EVADER
					)
			1:
				emit_signal(
					"change_world_request", 
					GLOBAL.SceneName.RHYTHM_HERO_MAINMENU
					)
			2:
				# NOT IMPLEMENTED
#				emit_signal(
#					"change_world_request", 
#					GLOBAL.SceneName.CAIDA_PROCEDURAL
#					)
				pass
