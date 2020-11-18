extends Area2D
export(int) var speed = 30
export(float) var active_time = 0.5

var lock_x

func _ready():
	lock_x = global_position
	speed = speed * 15
	move()

func _physics_process(delta):
	position.x = to_local(lock_x).x
	if $Tween.is_active():
		position.y += speed * delta

func move():
	$Tween.interpolate_property(self, "modulate", null, Color.transparent, active_time, Tween.TRANS_BOUNCE)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_body_entered(_body):
	queue_free()
