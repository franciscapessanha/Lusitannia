extends Node2D

"""
Global Variables
===================================================================
"""
onready var bard = get_parent().get_node("Bard")
onready var door_pos = get_node("door_three").global_position
onready var new_pos = get_parent().get_node("third_floor/door_four").global_position

"""
Process function
===================================================================
If the bard goes through the door it will be transferred to the third floor 
and the camera limits will be changed.
"""

func _process(delta):
	if door_pos.distance_to(bard.global_position) < 45:
		bard.global_position = new_pos
		get_parent().get_node("Bard/Camera2D").limit_bottom = 1860
		#get_parent().get_node("Bard/Camera2D").limit_bottom += get_parent().get_node("Bard/Camera2D").limit_bottom/2
		get_parent().get_node("Bard").change_checkpoint()
		get_parent().get_node("third_floor/sounds/fight_sound").play()
		get_node("enemy_arrow").stop_shooting()
	pass
