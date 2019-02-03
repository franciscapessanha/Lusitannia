extends CanvasLayer

"""
Variables inicialization
================================= 
"""
onready var points = 0
onready var lifes = 3
onready var transparent_background = get_node("transparent_background")

onready var paused = false
onready var over = false
signal dead

"""
Takes life
================================= 
Takes one life and hides the respective marker
"""
func take_life():
	lifes -= 1
	if lifes == 2:
		get_node("first_life").modulate = Color(0, 0, 0)
	elif lifes == 1:
		get_node("second_life").modulate = Color(0, 0, 0)
	elif lifes == 0:
		get_node("last_life").modulate = Color(0, 0, 0)
	
	elif lifes == -1:
		over = true
		transparent_background.show()
		get_node("game_over").show()
		get_tree().paused = true
