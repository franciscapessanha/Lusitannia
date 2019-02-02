extends Node2D

onready var bard = get_parent().get_node("Bard")

func _process(delta):
	if bard.global_position.x > 2200:
		get_tree().change_scene("res://Scenes/Final.tscn")