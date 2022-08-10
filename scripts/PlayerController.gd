extends KinematicBody2D

var velocity : Vector2 = Vector2.ZERO
export var gravity : Vector2 = Vector2(0, -9.81)

export var speed : float
export var speed_up : float

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		print("Collided with: ", collision.collider.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity -= gravity
	move_and_slide(velocity)
	
	collision()
