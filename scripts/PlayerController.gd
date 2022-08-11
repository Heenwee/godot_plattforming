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

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func jump():
	if Input.is_action_just_pressed("jump"):
		jump = true
		jump_buffer = 0.1
	if is_grounded:
		if jump:
			velocity.y = -sqrt(jump_height * -2 * gravity.y)

func _process(delta):
	print(velocity)
	input.x = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	
	jump()
	if jump:
		jump_buffer -= delta
	if jump_buffer <= 0:
		jump = false

func collision():
	is_grounded = get_slide_count() > 0
	match is_grounded:
		true:
			if !jump:
				velocity.y = 1
		false:
			pass
	#for i in get_slide_count():
	#	velocity.y = -1
	#	var col = get_slide_collision(i)
		#print("Collided with: ", col.collider.name)

func clamping():
	var current_vel = Vector2(velocity.x, 0)
	var vel = current_vel.clamped(speed)
	velocity.x = vel.x
	
	if is_grounded:
		if input.x == 0:
			velocity.x *= ground_drag
			if velocity.x < 1 and velocity.x > -1:
				velocity.x = 0
	else:
		if input.x == 0:
			velocity.x *= air_drag

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity -= gravity
	velocity += input * speed_up
	move_and_slide(velocity)
	
	collision()
	if is_clamped:
		clamping()
