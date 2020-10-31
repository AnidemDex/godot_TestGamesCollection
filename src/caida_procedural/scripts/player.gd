extends KinematicBody2D

export(int) var horizontal_speed: int = 140
export(int) var jump_speed: int = 130
export(int) var gravity: int = 264

export(float, 0.0, 1.0) var friction = 0.5
export(float, 0.0, 1.0) var acceleration = 0.25

var actual_speed = Vector2.ZERO

func _physics_process(delta):
	var direction = get_direction()
	var is_jump_interrupted = (
		Input.is_action_just_released("key_up") 
		and actual_speed.y < 0.0
		)
	
	actual_speed = calculate_speed(actual_speed, direction, is_jump_interrupted)
	actual_speed = move_and_slide(actual_speed, Vector2.UP)
	
	actual_speed.y += gravity * delta


func calculate_speed(
	speed: Vector2,
	direction: Vector2, 
	is_jump_interrupted: bool) -> Vector2:
	
	if direction.x != 0:
		speed.x = lerp(
			speed.x, 
			horizontal_speed * direction.x,
			acceleration
			)
	else:
		speed.x = lerp(speed.x, 0, friction)
	
	if direction.y != 0.0:
		speed.y = jump_speed * direction.y
	if is_jump_interrupted:
		speed.y = 0.0
	
	return speed


func get_direction() -> Vector2:
	var x = Input.get_action_strength("key_right") - Input.get_action_strength("key_left")
	var y = (
		-Input.get_action_strength("key_up") 
		if is_on_floor() and Input.is_action_just_pressed("key_up") 
		else 0.0
		)

	return Vector2(x, y)