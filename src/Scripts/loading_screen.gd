extends Control

signal finished_animation

onready var transition : AnimationPlayer = $Transitions

func _ready() -> void:
	pass

func update_bar(new_percent):
	$LoadTween.interpolate_property(
		$LoadingBar, 
		"value", 
		$LoadingBar.value, 
		new_percent, 
		0.5, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN
		)
	$LoadTween.start()
	
	yield($LoadTween, "tween_completed")
	
	if new_percent == $LoadingBar.max_value:
		$Transitions.play("FadeOut")
