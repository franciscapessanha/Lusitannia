extends KinematicBody2D

onready var velocity = Vector2()
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func move(velocity):
	velocity = move_and_slide(velocity, Vector2(0,-1))