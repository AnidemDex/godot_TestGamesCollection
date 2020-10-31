extends AnimatedSprite

var owner_direction : Vector2 = Vector2.ZERO

func _ready():
	playing = true

func _process(delta):
	var selected_animation = ""

	owner_direction = owner.get_direction()
	
	
	if owner_direction.x < 0:
		flip_h = true
	if owner_direction.x > 0:
		flip_h = false
	
	
	if owner.is_on_floor():
		selected_animation = "idle"
	
	if owner_direction.x != 0:
		if abs(owner.actual_speed.x) > 0.5:
			selected_animation = "walk"
	
	if owner.actual_speed.y < 0:
		selected_animation = "jump"
	
	if owner.actual_speed.y > 0 and (not owner.is_on_floor()):
		selected_animation = "fall"
	
	play(selected_animation)
