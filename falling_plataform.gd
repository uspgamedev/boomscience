
extends RigidBody2D

var timer = 0.5
var is_falling = false
var epslon = 9


func _fixed_process(delta):
	if timer >= 0:
		randomize()
		var randomx = (randf() * 2*epslon) - epslon
		randomize()
		var randomy = (randf() * 2*epslon) - epslon
		
		timer -= delta
		get_node("Sprite").set_pos(Vector2(randomx, randomy))
	else:
		set_mode(2)
		is_falling = true
		set_fixed_process(false)

func _on_falling_plataform_body_enter( body ):
	if body.is_in_group("Player") and is_falling == false:
		set_fixed_process(true)
	elif is_falling and !body.is_in_group("Player"):
		death()

func _on_Area2D_body_enter( body ): # Deleta a plataforma em queda exclusivamente se o jogador estiver SOB ela
	if is_falling and body.is_in_group("Player"):
		death()

func death():
	queue_free()
