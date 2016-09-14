extends KinematicBody2D

const G = 10 # Gravity
const EPSILON = 1
var v = Vector2() # Velocity
var hp # Health points
var direction # 1 = right, -1 = left
var normal # Normal force, perpendicular to the surface
var motion # Displacement

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	set_gravitational_force(delta)
	move(v)
	deaccelerate()

func set_gravitational_force(delta):
	# This is from Godot tutorials: Kinematic Character (2D)
	v.y += delta * G
	
	motion = v * delta
	motion = move(motion)
	
	if (is_colliding()):
		normal = get_collision_normal()
		motion = normal.slide(motion)
		v = normal.slide(v)
		move(motion)

func deaccelerate():
	if (v.x < EPSILON):
		v.x = 0
	else:
		v.x *= .8
	v.y *= .99
