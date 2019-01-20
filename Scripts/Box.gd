extends KinematicBody2D

onready var velocity = Vector2()
onready var direction = Vector2()

func move(velocity, delta, bard_position):
	direction.x = (bard_position.x - global_position.x)
	direction.y = 0
	move_and_slide(-direction.normalized() * velocity*2)