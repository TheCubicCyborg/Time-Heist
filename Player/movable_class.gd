@abstract
class_name Movable
extends Node

@export var MAX_SPEED = 4
@export var ACCELERATION = 1

func get_movement_direction() -> Vector3:
	return Vector3.ZERO

func can_jump() -> bool:
	return false
