extends 'res://scripts/body.gd'

var anim = 'idle'
var anim_new
var max_speed = 100
var dir = -1
var timer = 2
var temp = 0
onready var area_polygon_left = Vector2Array([Vector2(0,0), Vector2(-100,30), Vector2(-100, -30)])
onready var area_polygon_right = Vector2Array([Vector2(0,0), Vector2(100,30), Vector2(100, -30)])

onready var area_detection = get_node("AreaDetection")

func _ready():
	sprite = get_node('BasicEnemySprite')
	hp = 100
	get_node('LifeBar').change_life(hp, 0)
	set_fixed_process(true)
	
func _fixed_process(delta):
	check_animation()
	routine(delta)
	
func check_animation():
	if (!speed.x):
		anim_new = 'idle'
	else:
		anim_new = 'walk'
	if (anim != anim_new):
		anim = anim_new
		get_node('BasicEnemySprite/BasicEnemyAnimation').play(anim)
	
func routine(delta):
	speed.x = dir * max_speed
	temp += delta
	if (temp >= timer):
		temp = 0
		dir *= -1
		sprite.set_flip_h(max(dir, 0))
		if (area_detection.get_node("Polygon2D").get_polygon() == area_polygon_left):
			area_detection.get_node("Polygon2D").set_polygon(area_polygon_right)
			#area_detection.get_shape(
			
		else:
			area_detection.get_node("Polygon2D").set_polygon(area_polygon_left)
		#print(area_detection.get_polygon())

func take_damage(damage):
	get_node('LifeBar').change_life(hp, -damage)
	hp -= damage
	if (hp <= 0):
		die()

func die():
	self.queue_free()


func _on_AreaDetection_area_enter( area ):
	if (area.get_name() == "PlayerAreaDetection"):
		print("enter")


func _on_AreaDetection_area_exit( area ):
	if (area.get_name() == "PlayerAreaDetection"):
		print("exit")
