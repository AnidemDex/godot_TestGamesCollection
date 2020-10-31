extends Control

var extra_info = false

func _on_GameInfoPanel_change_world_request(world) -> void:
	GLOBAL.change_world(GLOBAL.SCENES[world])


func _on_RightMenu_mid_button_pressed() -> void:
	if not extra_info:
		extra_info = true
		$RightMenu/CreditsButton.disabled = true
		$GameSelector.animate_out()
		$GameInfoPanel.show_extra_info(GAMEMETADATA.GameInfo.CREDITS)

func _on_GameInfoPanel_back_button_pressed():
	$GameInfoPanel.hide_extra_info()
	yield($GameInfoPanel.tween, "tween_all_completed")
	$GameSelector.animate_in()
	yield($GameSelector.tween, "tween_all_completed")
	$RightMenu/CreditsButton.disabled = false
	extra_info = false
