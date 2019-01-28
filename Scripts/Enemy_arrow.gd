extends KinematicBody2D

"""
Global Variables
===================================================================
"""
onready var animations = get_node("animations")
onready var arrows_node = get_node("arrows")
onready var arrow = preload("res://Scenes/Arrow.tscn")
onready var shotter_timer = get_node("shooter_timer")
onready var arrow_sound = get_node("arrow_sound")
var new_arrow
var collision_identified = false

"""
Enemy shoot
================================= 
The enemy starts shooting.
"""
func shoot():
	shotter_timer.start()
	new_arrow = arrow.instance()
	arrows_node.add_child(new_arrow)
	new_arrow.shoot(global_rotation, get_node("arrow_point").global_position)
	arrow_sound.play()

"""
Stop shooting
================================= 
"""
func stop_shooting():
	shotter_timer.stop()

"""
Process
================================= 
The enemy will not attack until the Bard is close enough.
"""
func _process(delta):
	animations.play("idle")

"""
Shooter timer
================================= 
"""
func _on_shooter_timer_timeout():
	animations.play("attack")
	shoot()

"""
Start shooting
================================= 
"""
func start_shooting():
	animations.play("attack")
	shoot()
