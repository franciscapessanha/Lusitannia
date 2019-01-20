extends StaticBody2D

onready var bard = get_parent().get_node("Bard")
onready var door_pos = get_node("door_two_0").global_position
onready var new_pos = get_parent().get_node("scene_three/door_two_1").global_position
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	print(door_pos.distance_to(bard.global_position))
	if door_pos.distance_to(bard.global_position) < 45:
		bard.global_position = new_pos
		get_parent().get_node("Bard/Camera2D").limit_bottom += get_parent().get_node("Bard/Camera2D").limit_bottom/2 
	pass
