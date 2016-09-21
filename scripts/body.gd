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
	#self.speed += directions.get_dir(dir) * ACC
	self.speed += DIR.VECTOR[dir] * ACC

func check_if_floor(collider, normal):
	if collider extends StaticBody2D:
		var angle = atan2( normal.x, -normal.y )
		if angle > PI/4 and angle < 3*PI/4:
			can_jump = true

func apply_speed(delta):
	var motion = move(self.speed * delta)
	if is_colliding():
		var collider = get_collider()
		var normal = get_collision_normal()
		check_if_floor(collider, normal)
		motion = .01 * normal.slide(self.speed)
		move(motion)

func apply_gravity(delta):
	speed.y += delta * G

func jump(dir):
	if !can_jump: return
	if dir == DIR.UP or dir == DIR.UP_LEFT or dir == DIR.UP_RIGHT:
		speed -= Vector2(0, 0.1 * G)
		can_jump = false

func deaccelerate():
	if (speed.length_squared() < EPSILON):
		speed.x = 0
	else:
		speed.x *= .5
	speed.y *= .8
