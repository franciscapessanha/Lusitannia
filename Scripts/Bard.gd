extends KinematicBody2D
"""
Global Variables
=======================================================
"""
onready var animations = get_node("animations")
onready var jump_timer = get_node("jump_timer")
onready var read_input = true
onready var mode = "exploring"
onready var feet = get_node("feet")

#Sounds
onready var steps_sounds = get_node("steps/steps")
onready var jump_sounds = [get_node("jump/jump_0"),get_node("jump/jump_1"), get_node("jump/jump_2"),get_node("jump/jump_3")]
onready var crawl_sounds = get_node("crawl/crawl")
onready var pulling_sounds = get_node("pull_push/pulling")
var steps_sound_on = false
var crawl_sound_on = false
var pulling_sound_on = false

#Collision shapes
onready var crawl = get_node("crawl_collision")
onready var idle = get_node("idle_collision")
onready var play = get_node("play_collision")
onready var jump = get_node("jump_collision")
onready var pull = get_node("pull_collision")
onready var push = get_node("push_collision")
onready var run = get_node("run_collision")
onready var actions = [crawl, idle, play, jump, pull, push, run]
onready var action = "idle"
onready var action_shape = idle
onready var first_step


#Motion parameters
var velocity = Vector2(0,0)
var run_speed = 200
var gravity = 1125
var jump_speed = -470
var crawling = false

#Moving box parameters
var pulling = false
onready var box = get_parent().get_node("first_floor/box")
onready var box_position = box.global_position
var found_box = false
onready var moving_right = true

#Game mode - general parameters
var sheet

#Rhythm game mode parameters
var s = 0
var jumping_steps = false
onready var jump_stairs_timer = get_node("jump_stairs_timer")

#Melody game mode parameters
onready var melody_timer = get_node("melody_timer")

#"God" mode
onready var deadly_object = []
var type 
onready var checkpoints = [get_parent().get_node("checkpoints/first").global_position, 
get_parent().get_node("checkpoints/second").global_position, 
get_parent().get_node("checkpoints/third").global_position]
onready var start = 0 

#Enemy with arrow - position control
onready var shooting = get_parent().get_node("second_floor/start_shooting").global_position
onready var arrow_shooting = false
onready var alive = true

#Kill enemy
onready var collision_timer = get_node("collision_timer")
var check_collision = true
"""
Ready Function
===================================================================
"""
func _ready():	
	animations.play(action)
	handle_collision_shapes(action_shape)
	set_physics_process(true)
	get_parent().get_node("sounds/background").play()
	
	pass

"""
Handle collision shapes
===================================================================
Activate/disable the collision shapes according to the current action.

Arguments:
	* action: current action (walk or attack)
"""
func handle_collision_shapes(action):
	for i in range(len(actions)):
		if action == actions[i]:
			actions[i].disabled = false
		else:
			actions[i].disabled = true
"""
Stop all sounds
===================================================================
Will stop all sounds at the beginning of a challenge.
"""
func stop_all_sounds():
	steps_sounds.stop()
	crawl_sounds.stop()
	pulling_sounds.stop()	
	for i in range(len(jump_sounds)):
		jump_sounds[i].stop()
	get_parent().get_node("sounds/background").stop()
	get_parent().get_node("sounds/0_rhythm").stop()
	get_parent().get_node("sounds/1_rhythm").stop()
	get_parent().get_node("sounds/2_melody").stop()

"""
Get Input
===================================================================
"""
func get_input():
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var up = Input.is_action_just_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var select = Input.is_action_just_pressed("ui_select")
	
	if mode == "exploring":
		velocity.x = 0		
		if is_on_floor() and up:
			if crawling:
				action = "idle"
				action_shape = idle
				crawl_sounds.stop()
				crawl_sound_on = false
			elif !pulling:
				action = "jump"	
				action_shape = jump
				jump_timer.start()
				read_input = false
				jump_sounds[randi()%(len(jump_sounds))].play() 
			crawling = false #change position from crawl to standing up
		elif right:
			velocity.x += run_speed
			if !crawling and !pulling:
				action = "run"
				action_shape = run
				moving_right = true	
				if !steps_sound_on: 
					steps_sounds.play() 
					steps_sound_on = true
			if !pulling:
				animations.set_flip_h(false)
				for action in actions:
					action.set_scale(Vector2(1, 1))
			if pulling and moving_right:
				action = "push"
				action_shape = push
			if pulling and !moving_right:
				action = "pull"
				action_shape = pull
			if crawling:
				if !crawl_sound_on:
					crawl_sounds.play() 
					crawl_sound_on = true
		elif left:
			velocity.x -= run_speed
			if !crawling and !pulling:
				action = "run"
				action_shape = run
				moving_right = false
				if !steps_sound_on: 
					steps_sounds.play() 
					steps_sound_on = true
			if !pulling:	
				animations.set_flip_h(true)
				for action in actions:
					action.set_scale(Vector2(-1, 1))
			if pulling and moving_right:
				action = "pull"
				action_shape = pull
			if pulling and !moving_right:
				action = "push"
				action_shape = push	
			if crawling:
				if !crawl_sound_on:
					crawl_sounds.play() 
					crawl_sound_on = true
		elif is_on_floor() and down:
			action = "crawl"
			action_shape = crawl
			crawling = true
		elif select and found_box:
			if !pulling:
				pulling = true
				action = "pull"
				action_shape = pull
				pulling_sounds.play()
			elif pulling:
				pulling = false
				found_box = false
				pulling_sounds.stop()
		else:
			if !crawling and !pulling:
				action = "idle"
				action_shape = idle
				steps_sounds.stop()
				steps_sound_on = false
			else:
				crawl_sounds.stop()
				crawl_sound_on = false
"""
Normal physics
===================================================================
Physics function when on exploring mode.

Arguments:
	* delta
"""
func normal_physics(delta):
	velocity = move_and_slide(velocity, Vector2(0,-1))
	var collision = move_and_collide(velocity * delta)	
	if collision:
		if collision.collider.has_method("collect_rhythm"):
			mode = "rhythm"
			collision.collider.collect_rhythm()
			sheet = collision.collider
			first_step = sheet.get_first_step()
			rhythm_game_mode()
			stop_all_sounds()
			get_parent().get_node("sounds/start_game").play()
	
		elif collision.collider.has_method("collect_melody"):
			collision.collider.collect_melody()
			mode = "melody"
			sheet = collision.collider
			stop_all_sounds()
			get_parent().get_node("sounds/start_game").play()
	
		elif collision.collider.has_method("deadly"):
			deadly_object = collision.collider
			type = "object"
			lost_life(type, [])
			stop_all_sounds()
		if collision.collider.has_method("collision_with_enemy") and check_collision:
			collision.collider.collision_with_enemy(feet.global_position)
			check_collision = false
			collision_timer.start()
	
	#When pushing/pulling a object
	if pulling:
		box.move(velocity, delta, global_position)
	if abs(box_position.x - global_position.x) < 200:
		found_box = true
	else:
		found_box = false
"""
Rhythm physics
===================================================================
Physics function when on rhytmic mode.

Arguments:
	* delta
"""
func rhythm_physics(delta):
	if !jumping_steps and !read_input:
		action = "play"
		action_shape = play
		sheet.set_process(true)	
	elif jumping_steps:
		var direction = Vector2()
		direction = (first_step - global_position)
		velocity = move_and_slide(Vector2(direction.x * 50, jump_speed))
		
"""
Melody physics
===================================================================
Physics function when on melodic mode.
Arguments:
	* delta
"""	
func melody_physics(delta):
	velocity = move_and_slide(velocity, Vector2(0,-1))
	var collision = move_and_collide(velocity * delta)	
	action = "play"
	action_shape = play
	melody_timer.start()

"""
Physics process function
===================================================================
"""
func _physics_process(delta):
	velocity.y += gravity * delta
	if !arrow_shooting and abs(global_position.x - shooting.x) < 100:
		if abs(global_position.y - shooting.y) < 400:
			get_parent().get_node("second_floor/enemy_arrow").start_shooting()
			arrow_shooting  = true
	if !jumping_steps:
		velocity.x = 0
	if read_input:
		get_input()
	if mode == "exploring":
		normal_physics(delta)
	if mode == "rhythm":
		rhythm_physics(delta)
	if mode == "melody":
		melody_physics(delta)
	
	animations.play(action)
	handle_collision_shapes(action_shape)


"""
Lost life
===================================================================
"""
func lost_life(type, enemy_actions):
	if alive and check_collision:
		get_parent().get_node("sounds/lost_life").play()
		alive = false
		get_parent().get_node("UI").take_life()
		read_input = false
		animations.modulate = Color(1,1,1,0.5)
		action = "die"
		mode = "exploring"
		for i in range(len(actions)):
			actions[i].disabled = true
		if type == "object":
			#deadly_object.get_node("collision").disabled = true
			pass
		if type == "mug":
			pass
		

"""
Change checkpoint
===================================================================
"""
func change_checkpoint():
	start += 1
"""
Jumping stairs
===================================================================
"""
func jump_stairs():
	action = "jump"	
	action_shape = jump
	jump_stairs_timer.start()
	jump_timer.start()
	read_input = false
	jumping_steps = true


# ********************
# TIMERS AND UTILITIES
# ********************

# Animation finished
# ===================================================================

func _on_animations_animation_finished():
	if action == "jump":
		read_input = true
	if action == "die":
		read_input = true
		global_position = checkpoints[start]
		animations.modulate = Color(1,1,1,1)
		alive = true
		if start == 0:
			get_parent().get_node("first_floor/enemy").reset_enemy()
			get_parent().get_node("sounds/background").play()
		if start == 1:
			get_parent().get_node("second_floor/sheet_0").reset_rhythm()
			get_parent().get_node("second_floor/enemy_arrow").stop_shooting()
			get_parent().get_node("sounds/background").play()
			jumping_steps = false
		
		if start == 2:
			get_parent().get_node("third_floor/sheet_1").reset_rhythm()
			get_parent().get_node("third_floor/sheet_2").reset_melody()
			get_parent().get_node("third_floor/sounds/fight_sound").play()
			get_parent().get_node("sounds/background").play()
			get_parent().get_node("sounds/0_rhythm").play()
			get_parent().get_node("second_floor/enemy_arrow").stop_shooting()
			
			jumping_steps = false
		arrow_shooting = false
# Jump timer
# ===================================================================
# Gives time for the bard to go down before jumping
func _on_jump_timer_timeout():
	velocity.y = jump_speed

# Rhythmic game mode
# ===================================================================
func rhythm_game_mode():
	action = "play"
	action_shape = play
	mode = "rhythm"
# Change mode
# ===================================================================
func change_mode(new_mode):
	mode = new_mode
	if new_mode == "exploring":
		action= "idle"
		action_shape = idle
# Jump stairs timer
# ===================================================================
func _on_jump_stairs_timer_timeout():
		jumping_steps = false
		mode = "exploring"
# Melody timer
# ===================================================================
func _on_melody_timer_timeout():
	sheet.generate_next_mug()

# Collect sheet to the left
# ===================================================================
func collect_left():
	animations.set_flip_h(true)
	for action in actions:
		action.set_scale(Vector2(1, 1))

# Collect sheet to the right
# ===================================================================
func collect_right():
	animations.set_flip_h(false)
	for action in actions:
		action.set_scale(Vector2(-1, 1))

# *************
# SOUND CONTROL
# *************
# It will replay the sound of the action if the action continues and stop it if it doesn't.

# Steps Sound
#===================================================================
func _on_steps_finished():
	if action == "run":
		steps_sounds.play()
	else:
		steps_sound_on = false
# Crawl Sound
#===================================================================
func _on_crawl_finished():
	if action == "crawl":
		crawl_sounds.play()
	else:
		crawl_sound_on = false
# Crawl Sound
#===================================================================
func _on_pulling_finished():
	if action == "pull" or action == "push": 
		pulling_sounds.play()

# Collision Timer
#===================================================================
func _on_collision_timer_timeout():
	check_collision = true

Loop background sounds
#===================================================================
func _on_background_finished():
	get_parent().get_node("sounds/background").play()

func _on_0_rhythm_finished():
	get_parent().get_node("sounds/0_rhythm").play()

func _on_1_rhythm_finished():
	get_parent().get_node("sounds/1_rhythm").play()


func _on_2_melody_finished():
	get_parent().get_node("sounds/2_rhythm").play()
