extends CPUParticles2D

func _ready():
	if one_shot:
		emitting = true
	
	print("particle")
	var timer = Timer.new()
	add_child(timer)
	
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()
