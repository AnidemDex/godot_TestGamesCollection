extends TextureProgress

var max_health = CP_PLAYERDATA.default_health
var actual_health = CP_PLAYERDATA.health

onready var health_label = $Label

func _ready() -> void:
	health_label.text = String(actual_health)+"/"+String(max_health)
	
	max_value = max_health
	value = actual_health


func _process(delta: float) -> void:
	health_label.text = String(actual_health)+"/"+String(max_health)
	
	max_value = max_health
	value = actual_health
