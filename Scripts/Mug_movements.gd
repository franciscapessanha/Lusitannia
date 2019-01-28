extends Node

onready var paths = [get_node("path_0"), get_node("path_1"), get_node("path_2"),
get_node("path_3")]
#onready var path_hit = get_node("path_hit")

onready var mug = preload("res://Scenes/Mug.tscn")
var path
var new_mug
var follow
onready var mug_timer = get_node("mug_break")

func change_label(Label):
	new_mug.get_node("Label").set_text(Label)
	
func _ready():
	path = paths[randi() % paths.size()]
	new_mug = mug.instance()
	follow = PathFollow2D.new()
	follow.set_rotate(true)
	path.add_child(follow)
	follow.add_child(new_mug)


"""
Process function
================================= 
"""
func _process(delta):
	if follow.get_unit_offset() > 0.99:
		mug_timer.start()
		new_mug.get_node("Label").set_text("")
		new_mug.get_node("animations").play("break")
		
	else:
		follow.set_offset(follow.get_offset() + 600*delta)

func _on_mug_break_timeout():
	get_parent().generate_next_mug()
	new_mug.queue_free()
	queue_free()

