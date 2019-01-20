extends KinematicBody2D

onready var animations = get_node("animations")
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	animations.play("going")

