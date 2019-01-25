extends StaticBody2D

onready var bard = get_parent().get_node("Bard")
onready var door_pos = get_node("door_one_0").global_position
onready var new_pos = get_parent().get_node("scene_two/door_one_1").global_position
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if door_pos.distance_to(bard.global_position) < 45:
		bard.global_position = new_pos
		get_parent().get_node("Bard/Camera2D").limit_bottom = get_parent().get_node("Bard/Camera2D").limit_bottom * 2
	pass
