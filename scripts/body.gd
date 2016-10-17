extends KinematicBody2D

const DIR = preload("directions.gd")
const ACT = preload("actions.gd")

const G = 4000 # Gravity
const EPSILON = 1

var speed = Vector2() # Velocity
var hp # Health points
var normal # Normal force, perpendicular to the surface
var motion # Displacement
var can_jump = false # Is on air
var jump_height = -1 # Holding jump modifies its height
var acc = 200

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	apply_gravity(delta)
	apply_speed(delta)
	deaccelerate()

func _jump(act):
	if (jump_height >= 0): # If already jumped
		jump_height = -1 # Can't modify jump height
	if (can_jump and act == ACT.JUMP):
		speed -= Vector2(0, .15 * G)
		jump_height = 0 # Can modify jump height

func _add_jump_height(act):
	if (act == ACT.JUMP and jump_height >= 0 and jump_height < 10): # Limit jump height
		speed -= Vector2(0, .03 * G)
		jump_height += 1

func _add_speed(dir):
	if (dir == DIR.LEFT or dir == DIR.UP_LEFT or dir == DIR.DOWN_LEFT):
		self.speed += DIR.VECTOR[DIR.LEFT] * acc
	if (dir == DIR.RIGHT or dir == DIR.UP_RIGHT or dir == DIR.DOWN_RIGHT):
		self.speed += DIR.VECTOR[DIR.RIGHT] * acc

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
	if (can_jump): # If on floor, there is no vertical speed
		speed.y = 0

func check_if_floor(collider, normal): # If body is stepping on floor
	if (collider extends StaticBody2D):
		var angle = atan2(normal.x, -normal.y)
		if (angle > -PI/4 and angle < PI/4): # From  45° to 135°
			can_jump = true
			jump_height = -1

func deaccelerate():
	if (speed.length_squared() < EPSILON):
		speed.x = 0
	else:
		speed.x *= .5
	speed.y *= .9
