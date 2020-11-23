extends Control

var bullets = CP_PLAYERDATA.bullets
var bullet_indicator = preload("res://src/caida_procedural/scenes/BulletIndicator.tscn")

onready var bullet_container = $BulletBar/VBoxContainer

func _ready() -> void:
	check_bullets()
	var _signal = CP_PLAYERDATA.connect("bullets_changed", self, "check_bullets")

func check_bullets():
	bullets = CP_PLAYERDATA.bullets
	var bullet_container_childrens: Array = bullet_container.get_children()
	
	for child in bullet_container_childrens:
			child.hide()
	
	if bullets > 0:
		bullets = clamp(bullets, 0, 18)
		for bullet in range(0, bullets):
			bullet_container_childrens[bullet].show()

