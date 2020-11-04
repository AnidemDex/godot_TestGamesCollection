tool
extends Node2D

export(float, -0.1, 0.5, 0.1) var test_range = 0.5

export(Vector2) var start_point = Vector2.ZERO
export(Vector2) var end_point = Vector2(64,64)
export(OpenSimplexNoise) var simple_noise

func _ready():
	$SolidEnviorment.clear()
	set_process(false)
	randomize()
	_check_simple_noise()
	generate_solid_enviorment()

func generate_solid_enviorment():
	for x in range(start_point.x, end_point.x):
		for y in range(start_point.y, end_point.y):
			var a = simple_noise.get_noise_2d(x, y)
			if a > test_range:
				$SolidEnviorment.set_cell(x,y,0)
	
	$SolidEnviorment.update_bitmask_region(Vector2.ZERO, end_point)
	pass

func _check_simple_noise():
	if simple_noise == null:
		simple_noise = OpenSimplexNoise.new()
		simple_noise.octaves = 1.0
		simple_noise.period = 12
		simple_noise.persistence = 0.7
	simple_noise.seed = randi()
