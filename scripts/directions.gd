extends Node

const INVALID    = 0
const UP         = 1
const RIGHT      = 2
const UP_RIGHT   = 3
const DOWN       = 4
const DOWN_RIGHT = 6
const LEFT       = 8
const UP_LEFT    = 9
const DOWN_LEFT  = 12

const VECTOR = [
	Vector2(),
	Vector2(cos(PI/2), -sin(PI/2)),   #UP
	Vector2(cos(0), -sin(0)),         #RIGHT
	Vector2(cos(PI/4), -sin(PI/4)),   #UP RIGHT
	Vector2(cos(-PI/2), -sin(-PI/2)), #DOWN
	Vector2(),
	Vector2(cos(-PI/4), -sin(-PI/4)), #DOWN RIGHT
	Vector2(),
	Vector2(cos(PI), -sin(PI)),       #LEFT
	Vector2(cos(3 * PI/4), -sin(3 * PI/4)), #UP LEFT
	Vector2(),
	Vector2(),
	Vector2(),
	Vector2(),
	Vector2(cos(-3 * PI/4), -sin(-3 * PI/4)), #DOWN LEFT
	Vector2(),
	Vector2(),
]
