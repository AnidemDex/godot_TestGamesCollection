extends Node

signal bullets_changed
signal default_health_changed

var default_bullets = 4 setget set_default_bullets
var bullets = 0 setget set_bullets

var default_health = 4 setget set_default_health
var health = 4 setget set_health

var player_freeze_world = false

var LevelProperties = {
	"size_y": 64,
	"smooth_times": 1,
	"floor_probability": 18,
	"store_probability": 20,
	"camera_limit": 1100
}

var level_number = 1
var level_attemps = 0

func reset():
	default_bullets = 8
	bullets = 0
	default_health = 4
	health = default_health
	player_freeze_world = false


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


func go_to_level():
	LevelProperties.size_y += 16*(level_number)
	LevelProperties.smooth_times += randi() % 4
	LevelProperties.smooth_times = clamp(LevelProperties.smooth_times, 1, 3)
	LevelProperties.floor_probability = (randi() % 51) +1
	LevelProperties.floor_probability = LevelProperties.floor_probability if (LevelProperties.smooth_times < 2) and (LevelProperties.floor_probability > 10) else LevelProperties.floor_probability/2
	LevelProperties.store_probability = randi() % 30
	level_number += 1
	GLOBAL.change_world(GLOBAL.SCENES[GLOBAL.SceneName.CAIDA_PROCEDURAL_LEVEL])
