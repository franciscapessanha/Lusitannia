extends KinematicBody2D
"""
Variables initialization
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
onready var next_step

#Motion parameters
var velocity = Vector2(0,0)
var run_speed = 200
var gravity = 1125
var jump_speed = -470
var crawling = false
var steps


#Moving box parameters
var pulling = false
onready var box = get_parent().get_node("scene_one/Box")
onready var box_position = get_parent().get_node("scene_one/Box/box_position").global_position
var found_box = false
onready var moving_right = true
var found_initial_pos = false

#Game mode - general parameters
onready var game_position = Vector2() #position where to start the game mode
var sheet

#Rythm game mode parameters
var s = 0
var jumping_steps = false
onready var jump_stairs_timer = get_node("jump_stairs_timer")
onready var melody_timer = get_node("melody_timer")

#Melody game mode parameters
var first_time = true

#"God" mode
onready var god_mode = get_node("god_mode") 
onready var deadly_object = []
var type 

onready var shooting = get_parent().get_node("start_shooting").global_position
onready var arrow_shooting = false

#===================================================================
func _ready():	
	animations.play(action)
	handle_collision_shapes(action_shape)
	set_physics_process(true)
	pass
#===================================================================
func handle_collision_shapes(action):
	for i in range(len(actions)):
		if action == actions[i]:
			actions[i].disabled = false
		else:
			actions[i].disabled = true
#===================================================================
func stop_all_sounds():
	steps_sounds.stop()
	crawl_sounds.stop()
	pulling_sounds.stop()	
	for i in range(len(jump_sounds)):
		jump_sounds[i].stop()


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
			else:
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
			#crawl_sounds.play() 
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
#===================================================================
func normal_physics(delta):
	velocity = move_and_slide(velocity, Vector2(0,-1))
	var collision = move_and_collide(velocity * delta)	
	if collision:
		if collision.collider.has_method("collect_rythm"):
			game_position = collision.collider.collect_rythm()
			sheet = collision.collider
			steps = sheet.get_steps()
			next_step = steps[s]
			rythm_game_mode()
			found_initial_pos = true
			stop_all_sounds()
			print("game position", game_position)
		elif collision.collider.has_method("collect_melody"):
			#game_position = collision.collider.collect_melody()
			collision.collider.collect_melody()
			mode = "melody"
			sheet = collision.collider
			found_initial_pos = true
			stop_all_sounds()
		if collision.collider.has_method("deadly"):
			deadly_object = collision.collider
			type = "object"
			lost_life(type, [])
			stop_all_sounds()
		if collision.collider.has_method("collision_with_enemy"):
			collision.collider.collision_with_enemy(feet.global_position)
			
	if pulling:
		box.move(velocity, delta, global_position)
	
	if abs(box_position.x - global_position.x) < 200:
		found_box = true
	else:
		found_box = false
#===================================================================
func rythm_physics(delta):
	velocity = move_and_slide(velocity, Vector2(0,-1))
	var collision = move_and_collide(velocity * delta)
	if !found_initial_pos: #dirigir-se até à posição inicial
		if global_position.x > 0.98 * game_position.x and global_position.x < 1.02 * game_position.x :
			action = "play"
			action_shape = play
			sheet.set_process(true)	
			found_initial_pos = true
		else:
			action = "run"
			action_shape = run
			var direction = Vector2()
			direction.x = (game_position.x - global_position.x)
			direction.y = 0
			print("direction", direction)
			velocity = move_and_slide(direction.normalized() * 100)
	elif jumping_steps and read_input:
		var direction = Vector2()
		direction = (next_step - global_position)
		velocity = move_and_slide(Vector2(direction.x * 2, direction.y * 0.1))
	else:
		velocity = move_and_slide(velocity, Vector2(0,-1))
		collision = move_and_collide(velocity * delta)
		
	if Input.is_action_just_pressed("ui_cancel"):
		read_input = true
		action = "idle"
		action_shape = idle
#===================================================================	
func melody_physics(delta):
	velocity = move_and_slide(velocity, Vector2(0,-1))
	var collision = move_and_collide(velocity * delta)	
	if !found_initial_pos: #dirigir-se até à posição inicial
		if global_position.x > 0.98 * game_position.x and global_position.x < 1.02 * game_position.x :
			action = "play"
			action_shape = play
			melody_timer.start()
			found_initial_pos = true
		else:
			action = "run"
			action_shape = run
			var direction = Vector2()
			direction.x = (game_position.x - global_position.x)
			direction.y = 0
			velocity = move_and_slide(direction.normalized() * 10)
	elif first_time:
		velocity = Vector2(0,0)
		action = "play"
		action_shape = play
		melody_timer.start()
		first_time = false
		
#===================================================================	
func _physics_process(delta):
	velocity.y += gravity * delta
	if !arrow_shooting and abs(global_position.x - shooting.x) < 50:
		if abs(global_position.y - shooting.y) < 400:
			get_parent().get_node("scene_two/Enemy_arrow").start_shooting()
		arrow_shooting = true
	if !jumping_steps:
		velocity.x = 0
	if read_input:
		get_input()
	if mode == "exploring":
		normal_physics(delta)
	if mode == "rythm":
		rythm_physics(delta)
	if mode == "melody":
		melody_physics(delta)
	animations.play(action)
	handle_collision_shapes(action_shape)
		
#===================================================================
func _on_animations_animation_finished():
	if action == "jump":
		read_input = true
#===================================================================
func _on_jump_timer_timeout():
	velocity.y = jump_speed
#===================================================================
func rythm_game_mode():
	action = "run"
	action_shape = run
	get_node("Camera2D").drag_margin_bottom = 1
	get_node("Camera2D").drag_margin_top = 0
	mode = "rythm"
#===================================================================
func change_mode(new_mode):
	mode = new_mode
	if new_mode == "exploring":
		action= "idle"
		action_shape = idle
		
#===================================================================
func _on_jump_stairs_timer_timeout():
	if s == 4:
		mode = "exploring"
		s = 0 
	else:
		s += 1
		next_step = steps[s]
		#jump_stairs()
		mode = "exploring"
#===================================================================
func _on_melody_timer_timeout():
	sheet.generate_next_mug()
#===================================================================
func lost_life(type, enemy_actions):
	get_parent().get_node("UI").take_life()
	god_mode.start()
	animations.modulate = Color(1,1,1,0.5)
	if type == "object":
		deadly_object.get_node("collision").disabled = true
	if type == "enemy":
		for i in range(len(enemy_actions)):
			enemy_actions[i].disabled = true
#===================================================================
func _on_god_mode_timeout():
	animations.modulate = Color(1,1,1,1)
	if type == "object":
		deadly_object.get_node("collision").disabled = false
		deadly_object = []
#===================================================================
func jump_stairs():
	action = "jump"	
	action_shape = jump
	jump_stairs_timer.start()
	jump_timer.start()
	jumping_steps = true
#===================================================================
func _on_steps_finished():
	if action == "run":
		steps_sounds.play()
	else:
		steps_sound_on = false
#===================================================================
func _on_crawl_finished():
	if action == "crawl":
		crawl_sounds.play()
	else:
		crawl_sound_on = false
#===================================================================
func _on_pulling_finished():
	if action == "pull" or action == "push": 
		pulling_sounds.play()
