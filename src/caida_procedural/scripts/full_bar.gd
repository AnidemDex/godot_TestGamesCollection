extends Control

onready var bullet_indicator_label = $VBoxContainer/MarginContainer/Bullet_Label

func _process(_delta: float) -> void:
	bullet_indicator_label.text = String(CP_PLAYERDATA.bullets)
