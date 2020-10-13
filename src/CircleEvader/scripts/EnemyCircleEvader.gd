extends KinematicBody2D

var player:Node2D
var min_vel = 150
var max_vel = 250
var direction = Vector2.ZERO
export var can_follow = true

func _ready() -> void:
	player = get_node("../PlayerSpawnPoint/Player")
	$AnimationPlayer.play("PreRotate")
	

func _process(_delta: float) -> void:
	print($AnimationPlayer.current_animation)
	if player != null:
		if can_follow:
			direction = player.global_position-position

func _physics_process(_delta: float) -> void:
	direction = move_and_slide(direction)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _on_FollowObjective_timeout() -> void:
	can_follow = false

func change_animation() -> void:
	$AnimationPlayer.play("Rotate")
