extends KinematicBody2D

onready var animations = get_node("animations")
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	animations.play("angry")
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
