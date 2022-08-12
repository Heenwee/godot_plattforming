extends Camera2D

var shake_power = 4
var shake_time = 0.4
var isShake = false
var curPos
var elapsedtime = 0

func _ready():
	get
	
	randomize()
	curPos = offset

func _process(delta):
	if isShake:
		do_shake(delta)    

func shake(mag : float, length : float):
	if !isShake:
		shake_power = mag
		shake_time = length
		
		elapsedtime = 0
		isShake = true

func do_shake(delta):
	if elapsedtime<shake_time:
		offset =  Vector2(randf(), randf()) * shake_power
		elapsedtime += delta
	else:
		isShake = false
		elapsedtime = 0
		offset = curPos
