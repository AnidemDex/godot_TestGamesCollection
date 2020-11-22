extends Area2D
export(int) var speed = 1
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
	if _body is TileMap:
		var offset = Vector2(0, 8)
		var tile_position = _body.world_to_map(_body.to_local(global_position+offset))
		var tile_id = _body.get_cellv(tile_position)
		if tile_id == 6:
			_body.set_cellv(tile_position, -1)
	queue_free()
