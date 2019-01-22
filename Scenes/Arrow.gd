extends KinematicBody2D

"""
Variables inicialization
================================= 
"""
var velocity = Vector2()
var speed = 500
var collision_identified = false 
func collision_handling(collision):
	if collision:
		if collision.collider.has_method("lost_life"):
			collision.collider.lost_life("enemy",[get_node("collision")])
			queue_free()

func shoot(enemy_rotation, arrow_position):
	global_position = arrow_position
	velocity = Vector2(speed,0)
	set_process(true)

func _process(delta):
	var collision = move_and_collide(velocity * delta)
	collision_handling(collision)
