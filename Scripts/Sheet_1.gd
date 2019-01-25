extends StaticBody2D
onready var collision = get_node("collision")
onready var sprite = get_node("sprite")

onready var stair_0  = get_parent().get_node("stair_0")
onready var stair_1  = get_parent().get_node("stair_1")
onready var stair_2  = get_parent().get_node("stair_2")
onready var stair_3  = get_parent().get_node("stair_3")

onready var note_0  = get_parent().get_node("note_0")
onready var note_1  = get_parent().get_node("note_1")
onready var note_2  = get_parent().get_node("note_2")
onready var note_3  = get_parent().get_node("note_3")

onready var notes = [note_0, note_1, note_2, note_3]
onready var stairs = [stair_0, stair_1, stair_2, stair_3]
onready var sounds = get_parent().get_node("sound")
onready var times = [0.236, 0.455, 0.224, 1.841]

onready var mode = "show"
onready var timer = get_parent().get_node("rythm_timer")
var i = 0
var wait = false

var time_start = 0
var time_now = 0
var time_elapsed = []
var offset = 200
func _ready():
	set_process(false)

func get_steps():
	var steps = [get_parent().get_node("step_0").global_position,
	get_parent().get_node("step_1").global_position,
	get_parent().get_node("step_2").global_position,
	get_parent().get_node("step_3").global_position,
	get_parent().get_node("step_4").global_position]
	return steps

func collect_rythm():
	collision.disabled = true
	sprite.hide()
	return get_parent().get_node("initial_position").global_position

func handle_stairs(stair):
		for k in range(len(stairs)):
			if stair == stairs[k]:
				stairs[k].get_node("collision").disabled = false
				stairs[k].get_node("sprite").play("on")
			else:
				stairs[k].get_node("collision").disabled = true
				stairs[k].get_node("sprite").play("off")

func _process(delta):
	if mode == "show" and !wait and i < (len(stairs)):
		notes[i].play()
		handle_stairs(stairs[i])
		timer.wait_time = times[i]
		timer.start()
		wait = true

	elif mode == "show" and i == 4:
		mode = "play"
		i = 0
		for j in range(len(stairs)):
			stairs[j].get_node("collision").disabled = true
			stairs[j].get_node("sprite").play("off")
	
	elif mode == "play" and i < 4:
		if Input.is_action_just_pressed("ui_select"):
			print("tocou")
			if i == 0:
				time_start = OS.get_ticks_msec()
				notes[i].play()
				handle_stairs(stairs[i])
				i +=1
			else:
				time_now = OS. get_ticks_msec() 
				time_elapsed.append(time_now - time_start)
				time_start = OS.get_ticks_msec()
				notes[i].play()
				handle_stairs(stairs[i])
				print(time_elapsed)
				i +=1
	
	elif mode == "play" and len(time_elapsed) == 3:
				
		if time_elapsed[0] > times[0]*1000 - offset and time_elapsed[0] < times[0]*1000 + offset:
			if time_elapsed[1] > times[1]*1000 - offset and time_elapsed[1] < times[1]*1000 +  offset:
				if time_elapsed[2] > times[2]*1000 - offset and time_elapsed[2] < times[1]*1000 + offset:		
					for i in range(len(stairs)):
						stairs[i].get_node("collision").disabled = false
						stairs[i].get_node("sprite").play("on")
		else:
			for i in range(len(stairs)):
				stairs[i].get_node("collision").disabled = true
				stairs[i].get_node("sprite").play("off")
		
		get_parent().get_parent().get_parent().get_node("Bard").jump_stairs()
		set_process(false)
		get_parent().get_parent().get_node("ritmo_1").play()
		"""
		
	elif mode == "play" and i == 4:
		mode = "show"
		time_elapsed = []
		var time_start = 0
		var time_now = 0
		"""	
func _on_sound_finished():
	#stairs[i-1].get_node("collision").disabled = true
	stairs[i-1].get_node("sprite").play("off")
	pass # replace with function body

func _on_rythm_timer_timeout():
	wait = false
	i += 1
	pass # replace with function body

