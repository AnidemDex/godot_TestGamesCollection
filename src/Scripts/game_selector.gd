extends Control

var game_index = 0


onready var game: Array = [
	$CircleEvaderSelector,
	$RhythmHeroSelector,
	]
	
onready var tween = $Tween

func _ready():
	put_first_selector()
	

func put_first_selector():
	tween.interpolate_property(game[0], "margin_top", null, 0, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(game[0], "margin_bottom", null, 181, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()

func change_to_next_selector():
	tween.interpolate_property(game[game_index], "margin_left", null, -300, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(game[game_index], "margin_right", null, -240, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(1.1), "timeout")
	
	game[game_index].margin_left = -139
	game[game_index].margin_right = 0
	game[game_index].margin_top = 260
	game[game_index].margin_bottom = -441
	
	game_index = game_index + 1 if game_index < game.size()-1 else 0
	tween.interpolate_property(game[game_index], "margin_top", null, 0, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(game[game_index], "margin_bottom", null, 181, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()
	


func _on_RhythmHeroSelector_next_button_pressed():
	change_to_next_selector()


func _on_CircleEvaderSelector_next_button_pressed():
	change_to_next_selector()
