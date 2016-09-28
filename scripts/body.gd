extends KinematicBody2D	

const DIR = preload("directions.gd")
const ACT = preload("actions.gd")

const G = 4000 # Gravity
const EPSILON = 1
const ACC = 200

var speed = Vector2() # Velocity
var hp # Health points
var normal # Normal force, perpendicular to the surface
var motion # Displacement
var directions = DIR.new()
var can_jump = false
var jump_height = -1

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	apply_gravity(delta)
	apply_speed(delta)
	deaccelerate()

func _jump(act):
	if (jump_height >= 0):
		jump_height = -1
	if (can_jump and act == ACT.JUMP):
		speed -= Vector2(0, .2 * G)
		jump_height = 0

func _jumping(act):
	if (jump_height >= 0 and jump_height < 10 and act == ACT.JUMP):
		speed -= Vector2(0, .02 * G)
		jump_height += 1

func _add_speed(dir):
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
	if (can_jump):
		speed.y = 0 # AKIRA, PLEASE NOTICE THAT LINE

func check_if_floor(collider, normal):
	if (collider extends StaticBody2D):
		var angle = atan2(normal.x, -normal.y)
		if (angle > -PI/4 and angle < PI/4):
			can_jump = true
			jump_height = -1

func deaccelerate():
	if (speed.length_squared() < EPSILON):
		speed.x = 0
	else:
		speed.x *= .5
	speed.y *= .9
