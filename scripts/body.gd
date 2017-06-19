extends KinematicBody2D

const DIR = preload('directions.gd')
const ACT = preload('actions.gd')

const G = 3000 # Gravity
const EPSILON = 1
const ACC = 150

onready var sprite = null
var speed = Vector2() # Velocity
var hp # Health points
var normal # Normal force, perpendicular to the surface
var motion # Displacement
var can_jump = false # Is on air
var jump_height = -1 # Holding jump modifies its height
var acc = ACC

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	apply_gravity(delta)
	apply_speed(delta)
	deaccelerate()

func set_jump(flag):
	self.can_jump = flag

func _jump(act):
	if (jump_height >= 0): # If already jumped
		jump_height = -1 # Can't modify jump height
	if (can_jump and act == ACT.JUMP):
		speed -= Vector2(0, .2 * G)
		jump_height = 0 # Can modify jump height
	set_jump(false)

func _add_jump_height(act):
	if (speed.y < EPSILON and speed.y > -EPSILON):
		jump_height = -1
	if (act == ACT.JUMP and jump_height >= 0 and jump_height < 13): # Limit jump height
		speed -= Vector2(0, .025 * G)
		jump_height += 1

func _add_speed(dir):
	if (dir == DIR.LEFT or dir == DIR.UP_LEFT or dir == DIR.DOWN_LEFT):
		self.speed += DIR.VECTOR[DIR.LEFT] * acc
	if (dir == DIR.RIGHT or dir == DIR.UP_RIGHT or dir == DIR.DOWN_RIGHT):
		self.speed += DIR.VECTOR[DIR.RIGHT] * acc

func _flip_sprite(dir):
	if (sprite != null):
		if (dir == DIR.RIGHT or dir == DIR.UP_RIGHT or dir == DIR.DOWN_RIGHT):
			sprite.set_flip_h(true)
		elif (dir == DIR.LEFT or dir == DIR.UP_LEFT or dir == DIR.DOWN_LEFT):
			sprite.set_flip_h(false)

func apply_gravity(delta):
	speed.y += delta * G

func apply_speed(delta):
	var motion = move(self.speed * delta)
	if (is_colliding()):
		var collider = get_collider()
		normal = get_collision_normal()
		speed += 2 * ACC * normal
		check_if_floor(collider, normal)
		motion = .01 * normal.slide(self.speed)
		move(motion)
	else:
		set_jump(false)
	if (can_jump and jump_height == -1): # If on floor, there is no vertical speed
		speed.y = 0

func check_if_floor(collider, normal): # If body is stepping on floor
	if (normal.y == 1):
		speed.y = 0
	if (collider extends TileMap):
		var angle = atan2(normal.x, -normal.y)
		if (angle > -PI/4 and angle < PI/4): # From  45° to 135°
			set_jump(true)
			jump_height = -1

func deaccelerate():
	if (speed.length_squared() < EPSILON):
		speed.x = 0
	else:
		speed.x *= .5
	speed.y *= .9
