extends StaticBody2D

onready var collision = get_node("collision")
onready var sprite = get_node("sprite")

"""
func collect():
	print("collect")
	collision.disabled = true
	sprite.hide()
	get_parent().get_node("Bard").game_mode()
	set_process(true)
"""