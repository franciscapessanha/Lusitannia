extends KinematicBody2D
"""
Global Variables
===================================================================
"""
onready var velocity = Vector2()
onready var direction = Vector2()

"""
Move
===================================================================
The box will move accordingly to the variables received.
Arguments:
	* velocity = movement velocity
	* delta
	* bard_position = position of the bard pushing/pulling the box
"""
func move(velocity, delta, bard_position):
	velocity.y = 0
	direction.x = (bard_position.x - global_position.x)
	direction.y = 0
	move_and_slide(-direction.normalized() * velocity*2)

