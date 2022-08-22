extends KinematicBody2D

var input : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO
export var gravity : Vector2 = Vector2(0, -9.81)

export var speed : float = 200
export var speed_up : float = 100
export var ground_drag : float = 0.9
export var air_drag : float = 0.95

var is_grounded : bool = false
var is_clamped : bool = true

var jump : bool = false
var jump_buffer : float
export var jump_height : float

onready var cam = find_node("Camera2D")

var jump_effect_scene = load("res://scenes/jump_particles.tscn")
var land_effect_scene = load("res://scenes/land_particles.tscn")

func jump(delta):
	if Input.is_action_just_pressed("jump"):
		jump = true
		jump_buffer = 0.1
	if is_grounded:
		if jump:
			velocity.y = -sqrt(jump_height * -2 * gravity.y)
			var jump_effect = jump_effect_scene.instance()
			jump_effect.position = position + Vector2(0, 20)
			get_parent().add_child(jump_effect)
	
	# jump buffer bs idfk i wrote this like a year ago but in c#
	if jump:
		jump_buffer -= delta
	if jump_buffer <= 0:
		jump = false

func _process(delta):
	input.x = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	
	jump(delta)

func collision():
	if get_slide_count() > 0 and !is_grounded:
		# land
		print("just landed")
		var land_effect = land_effect_scene.instance()
		land_effect.position = position + Vector2(0, 20)
		get_parent().add_child(land_effect)
	
	is_grounded = get_slide_count() > 0
	match is_grounded:
		true:
			if !jump:
				velocity.y = 1
		false:
			pass # im gonna add shit here at some point lmao

func clamping():
	# make sure the player stops speeding up when max speed is reached
	var current_vel = Vector2(velocity.x, 0)
	var vel = current_vel.clamped(speed)
	velocity.x = vel.x
	
	# stop moving when no input
	if is_grounded:
		if input.x == 0:
			velocity.x *= ground_drag
			if velocity.x < 1 and velocity.x > -1:
				velocity.x = 0
	else:
		if input.x == 0:
			velocity.x *= air_drag

func _physics_process(delta):
	velocity -= gravity
	velocity += input * speed_up
	move_and_slide(velocity)
	
	collision()
	if is_clamped:
		clamping()
