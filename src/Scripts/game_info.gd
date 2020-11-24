extends Control

signal change_world_request(world)
signal back_button_pressed

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
	


func show_extra_info(info: int):
	animate_out()
	yield(tween, "tween_all_completed")
	panel = $ExtraPanel
	info_label = $ExtraPanel/WhitePanel/Label
	animate_in(info)
	tween.interpolate_property(panel, "rect_position:y", null, -100, 0.5, Tween.TRANS_ELASTIC)
	tween.start()

func hide_extra_info():
	tween.interpolate_property(panel, "rect_position:y", null, 300, 0.5, Tween.TRANS_ELASTIC)
	tween.start()
	yield(tween, "tween_all_completed")
	panel.rect_position.y = -932
	info_label.text = ""
	panel = $Panel
	info_label = $Panel/WhitePanel/Label

func _prepare_panel():
	if selected_game != null:
		match selected_game:
			-3:
				# Top button
				pass
			-2:
				# Mid button
				info_label.text = GAMEMETADATA.Credits.dev
				pass
			-1:
				# Bot button
				pass
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
				# FIXME: Cambiar el nivel de PROCEDURAL_LEVEL a MAINMENU
				emit_signal(
					"change_world_request", 
					GLOBAL.SceneName.CAIDA_PROCEDURAL_LEVEL
					)
				pass


func _on_BackButton_pressed() -> void:
	emit_signal("back_button_pressed")
