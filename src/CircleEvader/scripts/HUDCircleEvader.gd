extends CanvasLayer

signal start_game

func show_message(text:String):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message("¡Se acabó!")
	
	yield($MessageTimer, "timeout")
	
	show_message("Muevete con el mouse y evita todo lo que se venga")
	$MessageLabel.show()
	
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed() -> void:
	$StartButton.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout() -> void:
	$MessageLabel.hide()
