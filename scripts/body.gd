extends KinematicBody2D	

const DIR = preload("directions.gd")
const G = 4000 # Gravity
const EPSILON = 1
const ACC = 200

var speed = Vector2() # Velocity
var hp # Health points
var normal # Normal force, perpendicular to the surface
var motion # Displacement
var directions = DIR.new()
var can_jump = false

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	apply_gravity(delta)
	apply_speed(delta)
	deaccelerate()

func _add_speed(dir):
	if (can_jump and (dir == DIR.UP or dir == DIR.UP_LEFT or dir == DIR.UP_RIGHT)):
		speed -= Vector2(0, .5 * G)
	if (dir == DIR.LEFT or dir == DIR.UP_LEFT):
		self.speed += DIR.VECTOR[DIR.LEFT] * ACC
	if (dir == DIR.RIGHT or dir == DIR.UP_RIGHT):
		self.speed += DIR.VECTOR[DIR.RIGHT] * ACC

func apply_gravity(delta):
	speed.y += delta * G

func apply_speed(delta):
	var motion = move(self.speed * delta)
	if (is_colliding()):
		var collider = get_collider()
		var normal = get_collision_normal()
		check_if_floor(collider, normal)
		motion = .01 * normal.slide(self.speed)
		move(motion)
	else:
		can_jump = false

func check_if_floor(collider, normal):
	if (collider extends StaticBody2D):
		var angle = atan2(normal.x, -normal.y)
		if (angle > -PI/4 and angle < PI/4):
			can_jump = true

func deaccelerate():
	if (speed.length_squared() < EPSILON):
		speed.x = 0
	else:
		speed.x *= .5
	speed.y *= .9
