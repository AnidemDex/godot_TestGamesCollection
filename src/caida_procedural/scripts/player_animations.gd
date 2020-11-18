extends AnimatedSprite

var owner_direction : Vector2 = Vector2.ZERO
var bullet_generated = false
var can_change_animation = true

func _ready():
	playing = true

func _process(_delta):
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
	
	if bullet_generated and (not owner.is_on_floor()):
		selected_animation = "hit"
	else:
		if owner.actual_speed.y < 0:
			selected_animation = "jump"
		
		if owner.actual_speed.y > 0 and (not owner.is_on_floor()):
			selected_animation = "fall"
	
	play(selected_animation)



func _on_BulletGenerator_bullet_generated():
	bullet_generated = true



func _on_PlayerAnimations_animation_finished():
	if animation == "hit":
		bullet_generated = false
