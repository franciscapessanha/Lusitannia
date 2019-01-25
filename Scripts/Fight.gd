extends KinematicBody2D

onready var animations = get_node("animations")
var animation = "going"

func change_animation(new_animation):
	animation = new_animation
func _process(delta):
	animations.play(animation)

