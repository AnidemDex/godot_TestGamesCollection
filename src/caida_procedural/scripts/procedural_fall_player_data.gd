extends Node

signal bullets_changed
signal default_health_changed

var default_bullets = 4 setget set_default_bullets
var bullets = 8 setget set_bullets

var default_health = 4 setget set_default_health
var health = 4 setget set_health

func reset():
	default_bullets = 8
	bullets = 0
	default_health = 4
	health = default_health


func set_default_bullets(value):
	default_bullets = value


func set_bullets(value):
	bullets = value
	emit_signal("bullets_changed")


func set_default_health(value):
	default_health = value
	emit_signal("default_health_changed")


func set_health(value):
	health = value

func reload_bullets():
	set_bullets(default_bullets)
