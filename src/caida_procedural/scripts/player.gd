extends KinematicBody2D
signal bullet_generated

export(int) var horizontal_speed: int = 140
export(int) var jump_speed: int = 130
export(int) var gravity: int = 264

export(float, 0.0, 1.0) var friction = 0.5
export(float, 0.0, 1.0) var acceleration = 0.25

# Mientras mas alto sea este valor, menos impulso tendrá
export(float, 1, 10, 1) var bullet_impulse: float = 10

var actual_speed = Vector2.ZERO
var enemy_impulse = 2
var default_bullets = CP_PLAYERDATA.default_bullets

var _bullets = CP_PLAYERDATA.bullets
var _bullet_impulse = false
var _enemy_stomped = false

func _ready() -> void:
	bullet_impulse = clamp(bullet_impulse, 0.001, 12)
	pass

func _process(_delta: float) -> void:
	default_bullets = CP_PLAYERDATA.default_bullets
	_bullets = CP_PLAYERDATA.bullets
	
	if is_on_floor():
		CP_PLAYERDATA.reload_bullets()

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
	if _bullet_impulse:
		speed.y = -jump_speed+(bullet_impulse*10)
		_bullet_impulse = false
	if _enemy_stomped:
		speed.y = -jump_speed/enemy_impulse
	
	return speed


func get_direction() -> Vector2:
	var x = Input.get_action_strength("key_right") - Input.get_action_strength("key_left")
	var y = (
		-Input.get_action_strength("key_up") 
		if is_on_floor() and Input.is_action_just_pressed("key_up") 
		else 0.0
		)

	return Vector2(x, y)


func _on_BulletGenerator_bullet_generated():
	_bullet_impulse = true
	CP_PLAYERDATA.bullets -= 1
	emit_signal("bullet_generated")


func _on_StompDetector_area_entered(_area: Area2D):
	_enemy_stomped = true
	


func _on_StompDetector_area_exited(_area: Area2D):
	_enemy_stomped = false
