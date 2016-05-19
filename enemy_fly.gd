
extends RigidBody2D

var enemy_particles_scn = preload("res://enemy_particles.xscn")
var particles_scn = preload("res://particles.xscn")
var direction_h = 1 # right = 1, left = -1
var speed = 100
var next_tile
var ray_cast
var ray_cast2
var sprite
var detection_box
var player
var life = 100
var life_bar
var current_speed
var count = 0
var lowest_height = 500
var fly_count = 0
var aggro_count = 0
var detected = false
var attacking = false

var lock_target = false
var lock_pos

func _ready():
	set_fixed_process(true)
	
	ray_cast = get_node("RayCast2D")
	ray_cast2 = get_node("RayCast2D 2")
	sprite = get_node("enemy")
	detection_box = get_node("detection_box")

	life_bar = get_node("lifebar")
	life_bar.set_max(life)

	ray_cast.add_exception(self)
	ray_cast2.add_exception(self)
	
func _fixed_process(delta):	
	if detected:
		aggressive(10, delta)
		if (player.get_stealth()):
			var dist
			dist = player.get_pos() - (get_pos() + Vector2(direction_h * 100,0))
			if (dist.length() <= 50):
				aggressive(15, delta)
			else:
				passive(delta)
	else:
		passive(delta)

	if attacking:
		aggro_count += delta
	
	
	count += delta
	if (count >= 5):
		direction_h *= -1
		ray_cast.set_scale(Vector2(ray_cast.get_scale().x * -1, 1))
		ray_cast2.set_pos(Vector2(ray_cast2.get_pos().x * -1, ray_cast2.get_pos().y))
		count = 0
	
	if direction_h == 1:
		sprite.set_flip_h(true)
	else:
		sprite.set_flip_h(false)
	
	life_bar.set_value(life)
	if life <= 0:
		death()

func bomb_collision(damage):
	life -= damage

func passive(delta):
	attacking = false
	lock_target = false
	move(200, speed * direction_h, 1, delta)
	
	if ray_cast2.is_colliding():
		lowest_height = get_pos().y
	
	fly_count += delta
	if (fly_count >= 1):
		lowest_height += 50
		fly_count = 0
	

func aggressive(acceleration, delta):
	attacking = true
	if !lock_target:
		lock_pos = player.get_pos()
		if lock_pos.x < get_pos().x:
			lock_pos.x = -1
		else:
			lock_pos.x = 1
		lowest_height = lock_pos.y - 20
		lock_target = true

	if aggro_count <= 3:
		move(100, 0, acceleration, delta)
	elif (aggro_count > 5):
		passive(delta)
		aggro_count = 0
	else:
		move_horizontal(speed * 3 * lock_pos.x, acceleration, delta)

	
#	if ((player.get_pos().x > get_pos().x and direction_h == -1) or (player.get_pos().x <= get_pos().x and direction_h == 1)):
#		direction_h *= -1
#		ray_cast2.set_pos(Vector2(ray_cast2.get_pos().x * -1, ray_cast2.get_pos().y))
#	move_horizontal(speed * 3 * direction_h)
	
func death():
	var particles = enemy_particles_scn.instance()
	get_parent().add_child(particles)
	particles.get_node("enemy_particles").set_pos(get_pos())
	queue_free()

func move(fly_force, speed, acceleration, delta):
	move_horizontal(speed, acceleration, delta)
	
	if (get_pos().y >= lowest_height):
		set_linear_velocity(Vector2(get_linear_velocity().x, -fly_force))

func move_horizontal(speed, acceleration, delta):
	current_speed = get_linear_velocity().x
	current_speed = lerp(current_speed, speed, acceleration * delta)
	set_linear_velocity(Vector2(current_speed, get_linear_velocity().y))



func _on_detection_box_body_enter( body ):
	if body.is_in_group("Player"):
		player = body
		detected = true


func _on_detection_box_body_exit( body ):
	if body.is_in_group("Player"):
		detected = false
		player = null