extends Node

const UP = 0
const RIGHT = 1
const DOWN = 2
const LEFT = 3
const UP_RIGHT = 4
const DOWN_RIGHT = 5
const DOWN_LEFT = 6
const UP_LEFT = 7

var __dirs = [
    Vector2(0, -1),
    Vector2(1, 0),
    Vector2(0, 1),
    Vector2(-1, 0),
    Vector2(1, -1),
    Vector2(1, 1),
    Vector2(-1, 1),
    Vector2(-1, -1)
]

func _init():
    for i in range(8):
        self.__dirs[i] = self.__dirs[i].normalized()

func get_dir(id):
    return self.__dirs[id]
