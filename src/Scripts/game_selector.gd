extends Control

signal item_started_out
signal item_finished_in(selected_game)

var game_index = 0

onready var game: Array = [
	$CircleEvaderSelector,
	$RhythmHeroSelector,
	$FallGameSelector,
	]
	
onready var tween = $Tween

func _ready():
	for item in game:
		item.margin_left = -139
		item.margin_right = 0
		item.margin_top = 260
		item.margin_bottom = -441
		item.connect("next_button_pressed", self, "change_to_next_selector")
	
	put_first_selector()
	

func put_first_selector():
	animate_in(0)
	yield(tween, "tween_all_completed")
	emit_signal("item_finished_in", 0)

func change_to_next_selector():
	animate_out()
	yield(tween, "tween_all_completed")
	
	_put_item_on_start_point()
	
	game_index = game_index + 1 if game_index < game.size()-1 else 0	
	animate_in()


func animate_in(index:int = game_index):
	tween.interpolate_property(game[index], 
	"margin_top", 
	null, 
	0, 
	1, 
	Tween.TRANS_ELASTIC, 
	Tween.EASE_IN_OUT
	)
	
	tween.interpolate_property(game[index], 
	"margin_bottom", 
	null, 
	181, 
	1, 
	Tween.TRANS_ELASTIC, 
	Tween.EASE_IN_OUT
	)
	
	tween.start()
	yield(tween, "tween_all_completed")
	emit_signal("item_finished_in", game_index)


func animate_out():
	emit_signal("item_started_out")
	
	tween.interpolate_property(
		game[game_index], 
		"margin_left", 
		null, 
		-300, 
		1, 
		Tween.TRANS_ELASTIC, 
		Tween.EASE_IN_OUT
		)

	tween.interpolate_property(
		game[game_index], 
		"margin_right", 
		null, 
		-240, 
		1, 
		Tween.TRANS_ELASTIC, 
		Tween.EASE_IN_OUT
		)

	tween.start()
	yield(tween, "tween_all_completed")
	_put_item_on_start_point()

func _put_item_on_start_point():
	game[game_index].margin_left = -139
	game[game_index].margin_right = 0
	game[game_index].margin_top = 260
	game[game_index].margin_bottom = -441
