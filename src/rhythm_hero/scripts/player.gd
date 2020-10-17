extends Node2D

enum NoteValue {
	NONE,
	PERFECT, 
	GOOD, 
	NICE, 
	BAD,
	MISS
	}

var direction = Vector2.ZERO
var current_note = null
var note_score = NoteValue.NONE

func _ready() -> void:
	$PlayerContainer/AnimatedSprite.play("iddle_1")
	$PlayerContainer/AnimatedSprite.playing = true
	pass

func _process(_delta: float) -> void:
	match direction.x:
		1.0:
			$PlayerContainer.position = $RightPosition.position
		-1.0:
			$PlayerContainer.position = $LeftPosition.position
		_:
			pass
	$PlayerContainer.scale = Vector2(direction.x, 1) if direction.x != 0 else Vector2(1,1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("key_left") or event.is_action_pressed("key_right"):
		direction = _get_direction()
		
		if event.is_action_pressed("key_left"):
			$LeftObjective/red_circle.scale = Vector2(1.5,1.5)
		
		if event.is_action_pressed("key_right"):
			$RightObjective/red_circle.scale = Vector2(1.5,1.5)
		
		if $PlayerContainer/AnimatedSprite.animation != "attack_1":
			$PlayerContainer/AnimatedSprite.play("attack_1")
		
		if current_note != null:
			match note_score:
				NoteValue.PERFECT:
					# Es una nota perfecta
					current_note.destroy(NoteValue.PERFECT)
					
				NoteValue.GOOD:
					# Es una nota casi perfecta
					current_note.destroy(NoteValue.GOOD)
					
				NoteValue.NICE:
					# Es una nota buena
					current_note.destroy(NoteValue.NICE)
					
				NoteValue.BAD:
					# Fallo brutalmente la nota
					current_note.destroy(NoteValue.BAD)
					
				_:
					pass
			current_note = null
		# TODO: aumentar la puntuacion despues de destruir

	if event.is_action_released("key_left") or event.is_action_released("key_right"):
		$RightObjective/red_circle.scale = Vector2(1,1)
		$LeftObjective/red_circle.scale = Vector2(1,1)

func _get_direction() -> Vector2:
	var delta_x = Input.get_action_strength("key_right") - Input.get_action_strength("key_left")
	return Vector2(delta_x, 0)


func _on_AnimatedSprite_animation_finished() -> void:
	$PlayerContainer/AnimatedSprite.play("iddle_2")
	pass # Replace with function body.


func _on_PerfectArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("music_notes"):
		note_score = NoteValue.PERFECT



func _on_GoodArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("music_notes"):
		note_score = NoteValue.GOOD


func _on_NiceArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("music_notes"):
		note_score = NoteValue.NICE
		current_note = area


func _on_BadArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("music_notes"):
		note_score = NoteValue.BAD


func _on_HitArea_area_exited(area):
	if area.is_in_group("music_notes"):
		note_score = NoteValue.NONE


func _on_BadArea_area_exited(area):
	if area.is_in_group("music_notes"):
		note_score = NoteValue.MISS
		area.destroy(note_score)
	pass # Replace with function body.
