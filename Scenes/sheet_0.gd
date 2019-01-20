extends StaticBody2D

onready var collision = get_node("collision")
onready var sprite = get_node("sprite")

onready var stair_0  = get_parent().get_node("stair_0")
onready var stair_1  = get_parent().get_node("stair_1")
onready var stair_2  = get_parent().get_node("stair_2")
onready var stair_3  = get_parent().get_node("stair_3")

onready var stairs = [stair_0, stair_1, stair_2, stair_3]
onready var sound = get_parent().get_node("sound")
onready var times = [0.725+0.725, 0.725+(0.725/2), 0.725+0.725, 0.725]

onready var mode = "show"
onready var timer = get_parent().get_node("rythm_timer")
var i = 0
var wait = false

func _ready():
	set_process(false)

func get_steps():
	var steps = [get_parent().get_node("step_0").global_position,
	get_parent().get_node("step_1").global_position,
	get_parent().get_node("step_2").global_position,
	get_parent().get_node("step_3").global_position,
	get_parent().get_node("step_4").global_position]
	return steps
func collect():
	print("collect")
	collision.disabled = true
	sprite.hide()
	return get_parent().get_node("initial_position").global_position

func handle_stairs(stair):
		for i in range(len(stairs)):
			if stair == stairs[i]:
				stairs[i].get_node("collision").disabled = false
				stairs[i].get_node("sprite").play("on")
			else:
				stairs[i].get_node("collision").disabled = true
				stairs[i].get_node("sprite").play("off")

func _process(delta):
	if mode == "show" and !wait and i < (len(stairs)):
		sound.play()
		handle_stairs(stairs[i])
		timer.wait_time = times[i]
		timer.start()
		wait = true
	elif i == 4:
		mode = "play"
		i = 0 
	elif mode == "play" and !wait and i < (len(stairs)):
		handle_stairs(stairs[i])
		timer.wait_time = times[i]
		sound.play()
		timer.start()
		wait = true

func _on_sound_finished():
	#stairs[i-1].get_node("collision").disabled = true
	stairs[i-1].get_node("sprite").play("off")
	pass # replace with function body

func _on_rythm_timer_timeout():
	wait = false
	i += 1
	pass # replace with function body

