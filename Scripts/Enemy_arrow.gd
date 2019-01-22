extends KinematicBody2D

onready var animations = get_node("animations")
onready var arrows_node = get_node("arrows")
onready var arrow= preload("res://Scenes/Arrow.tscn")
onready var shotter_timer = get_node("shooter_timer")
var new_arrow
var collision_identified = false

"""
Ready function
================================= 
"""
func _ready():
	animations.play("attack")
	shoot()
	set_process(true)

"""
Enemy shoot
================================= 
The enemy has shot
A new bullet set is created
"""
func shoot():
	shotter_timer.start()
	new_arrow = arrow.instance()
	arrows_node.add_child(new_arrow)
	new_arrow.shoot(global_rotation, get_node("arrow_point").global_position)

"""
The spaceship has collided
================================= 
The spaceship will be destroyed
"""
func has_collided():
	queue_free()

func _process(delta):
	animations.play("idle")

func _on_shooter_timer_timeout():
	animations.play("attack")
	shoot()

