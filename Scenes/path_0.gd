extends Path2D

onready var follow = get_node("follow")
func _process(delta):
	follow.set_offset(follow.get_offset()+ 1 + delta)
