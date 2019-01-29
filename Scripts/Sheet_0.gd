extends StaticBody2D

"""
Global Variables
===================================================================
"""
onready var collision = get_node("collision")
onready var sprite = get_node("sprite")

# Get stairs
onready var stair_0  = get_parent().get_node("stairs/stair_0")
onready var stair_1  = get_parent().get_node("stairs/stair_1")
onready var stair_2  = get_parent().get_node("stairs/stair_2")
onready var stair_3  = get_parent().get_node("stairs/stair_3")

# Get notes
onready var note_0  = get_parent().get_node("notes/note_0")
onready var note_1  = get_parent().get_node("notes/note_1")
onready var note_2  = get_parent().get_node("notes/note_2")
onready var note_3  = get_parent().get_node("notes/note_3")

onready var notes = [note_0, note_1, note_2, note_3]
onready var stairs = [stair_0, stair_1, stair_2, stair_3]
onready var times = [0.693, 0.731, 0.461, 0,.867]

onready var mode = "show"
onready var timer = get_parent().get_node("rhythm_timer")
var i = 0
var wait = false

var offset = 400
var time_start = 0
var time_now = 0
var time_elapsed = []

"""
Ready function
===================================================================
"""
func _ready():
	set_process(false)

"""
Get first step
===================================================================
Returns:
	* First step position
"""
func get_first_step():
	return get_parent().get_node("first_step").global_position

"""
Collect rhythm sheet
===================================================================
"""
func collect_rhythm():
	collision.disabled = true
	sprite.hide()
	set_process(true)
	get_parent().get_parent().get_node("Bard").collect_left()

"""
Reset rhythm sheet
===================================================================
"""
func reset_rhythm():
	set_process(false)
	collision.disabled = false
	sprite.show()
	mode = "show"
	i = 0
	time_elapsed = []

"""
Handle stairs
===================================================================
Handle the collision shapes and animations of the stairs, acoording 
to the rhythm played.

Arguments:
	* stair: active step
"""
func handle_stairs(stair):
		for k in range(len(stairs)):
			if stair == stairs[k]:
				stairs[k].get_node("collision").disabled = false
				stairs[k].get_node("sprite").play("on")
			else:
				stairs[k].get_node("collision").disabled = true
				stairs[k].get_node("sprite").play("off")
"""
Process Function
===================================================================
"""
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
				i +=1
	elif mode == "play" and len(time_elapsed) == 3: #if 4 notes were played
		if time_elapsed[0] > times[0]*1000 - offset and time_elapsed[0] < times[0]*1000 + offset:
			if time_elapsed[1] > times[1]*1000 - offset and time_elapsed[1] < times[1]*1000 +  offset:
				if time_elapsed[2] > times[2]*1000 - offset and time_elapsed[2] < times[1]*1000 + offset:			
					for i in range(len(stairs)):
						stairs[i].get_node("collision").disabled = false
						stairs[i].get_node("sprite").play("on")
					get_parent().get_parent().get_node("sounds/0_rhythm").play()
		else:
			for i in range(len(stairs)):
				stairs[i].get_node("collision").disabled = true
				stairs[i].get_node("sprite").play("off")
		#Bard will jump to the first step
		get_parent().get_parent().get_node("Bard").jump_stairs()
		#Background sound starts playing
		get_parent().get_parent().get_node("sounds/background").play()
		set_process(false)
"""
Sound Finished
===================================================================
The stair will be desabled when the sound is finished.
"""
func _on_sound_finished():
	stairs[i-1].get_node("sprite").play("off")
"""
Rhythm timer
===================================================================
"""
func _on_rhythm_timer_timeout():
	wait = false
	i += 1

