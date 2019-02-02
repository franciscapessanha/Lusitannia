extends Node

onready var mug = preload("res://Scenes/Mug.tscn")
var path
var new_mug
var follow
onready var mug_timer = get_node("mug_break")
onready var initial_pos = [get_node("initial_pos/pos_0"),get_node("initial_pos/pos_1"), get_node("initial_pos/pos_2"), get_node("initial_pos/pos_3")]
onready var final_pos = get_node("final_pos")

func change_label(Label):
	new_mug.get_node("Label").set_text(Label)
	
func _ready():
	new_mug = mug.instance()
	add_child(new_mug)
	new_mug.start_movement(initial_pos[randi() % initial_pos.size()].global_position, final_pos.global_position)

func break_mug():
	set_process(false)
	mug_timer.start()
	new_mug.get_node("Label").set_text("")
	new_mug.get_node("animations").play("break")
	new_mug.get_node("collision").disabled = true
	new_mug.set_physics_process(false)
	
func _on_mug_break_timeout():
	print("entrou no timer")
	get_parent().generate_next_mug()
	new_mug.queue_free()
	queue_free()
	

