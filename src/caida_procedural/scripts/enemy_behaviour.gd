extends Node2D
signal killed


onready var damage_collider = $DamageZone/CollisionShape2D
onready var hit_collider = $HitZone/CollisionShape2D

func _commit_dead():
	hit_collider.set_deferred("disabled", true)
	damage_collider.set_deferred("disabled", true)
	emit_signal("killed")


func _on_DamageZone_area_entered(area: Area2D):
	# Enemy takes damage
	if area.is_in_group("cosas_que_golpean"):
		_commit_dead()


func _on_HitZone_area_entered(area):
	# Enemy deals damage
	if area.is_in_group("bullets"):
		_commit_dead()
