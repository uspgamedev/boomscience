extends KinematicBody2D

const G = 200
var speed = Vector2()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	apply_gravity(delta)
	apply_speed(delta)

func apply_gravity(delta):
	speed.y += delta * G

func apply_speed(delta):
	pass
	#move(self.speed * delta)
