extends Control

signal mid_button_pressed

const BTN_TOP_POSITION = Vector2(32, 12)
const BTN_MID_POSITION = Vector2(21, 64)
const BTN_BOT_POSITION = Vector2(13, 127)

var animation_time_base = 1
var proportional_anim = 0.25

onready var tween = $Tween
onready var btn_top = $UpperButton
onready var btn_mid = $CreditsButton
onready var btn_bot = $LowerButton

onready var top_initial_pos = btn_top.rect_position
onready var mid_initial_pos = btn_mid.rect_position
onready var bot_initial_pos = btn_bot.rect_position

func _ready() -> void:
	animate_in()


func animate_in():
	tween.interpolate_property(
		btn_bot, 
		"rect_position", 
		null, 
		BTN_BOT_POSITION, 
		animation_time_base, 
		Tween.TRANS_ELASTIC
		)

	tween.interpolate_property(
		btn_mid, 
		"rect_position", 
		null, 
		BTN_MID_POSITION, 
		animation_time_base+proportional_anim, 
		Tween.TRANS_ELASTIC
		)

	tween.interpolate_property(
		btn_top, 
		"rect_position", 
		null, 
		BTN_TOP_POSITION, 
		animation_time_base+proportional_anim*2, 
		Tween.TRANS_ELASTIC
		)
		
	tween.start()

func animate_out():
	pass

func _on_CreditsButton_pressed() -> void:
	emit_signal("mid_button_pressed")
