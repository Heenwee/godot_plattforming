extends CPUParticles2D

export var destroy_time : float = 2.0

func _ready():
	if one_shot:
		emitting = true
	
	print("particle")
	var timer = Timer.new()
	add_child(timer)
	
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()
