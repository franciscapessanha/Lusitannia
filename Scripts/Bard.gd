extends KinematicBody2D
"""
Variables initialization
=======================================================
"""

onready var animations = get_node("animations")
onready var jump_timer = get_node("jump_timer")
onready var read_input = true

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
var jump_speed = -400
var crawling = false
var steps

#Moving box parameters
var pulling = false
var box
var found_box = false
onready var moving_right = true
var found_initial_pos = false

onready var game_position = Vector2() #position where to start the game mode
var game_mode = false
var sheet
var s = 0
var jumping_steps = false
onready var jump_stairs_timer = get_node("jump_stairs_timer")
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
func get_input():
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var up = Input.is_action_just_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var select = Input.is_action_just_pressed("ui_select")
	
	if !game_mode:
		velocity.x = 0		
		if is_on_floor() and up:
			if crawling:
				action = "idle"
				action_shape = idle
			else:
				action = "jump"	
				action_shape = jump
				jump_timer.start()
				read_input = false
				
			crawling = false #change position from crawl to standing up
		elif right:
			velocity.x += run_speed
			if !crawling and !pulling:
				action = "run"
				action_shape = run
				moving_right = true	
			if !pulling:
				animations.set_flip_h(false)
				for action in actions:
					action.set_scale(Vector2(1, 1))
			elif pulling and moving_right:
				action = "push"
				action_shape = push
			elif pulling and !moving_right:
				action = "pull"
				action_shape = pull	
		elif left:
			velocity.x -= run_speed
			if !crawling and !pulling:
				action = "run"
				action_shape = run
				moving_right = false
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
		elif is_on_floor() and down:
			action = "crawl"
			action_shape = crawl
			crawling = true
		elif select and found_box:
			if !pulling:
				pulling = true
				action = "pull"
				action_shape = pull
			elif pulling:
				pulling = false
				found_box = false
		else:
			if !crawling and !pulling:
				action = "idle"
				action_shape = idle
	else:
		if select:
			action = "jump"	
			action_shape = jump
			jump_stairs_timer.start()
			jump_timer.start()
			read_input = false
			jumping_steps = true
			
		else:
			action = "idle"
			action_shape = idle
#===================================================================
func normal_physics(delta):
	velocity = move_and_slide(velocity, Vector2(0,-1))
	var collision = move_and_collide(velocity * delta)	
	if collision:
		if  collision.collider.has_method("move"):
			box = collision.collider
			found_box = true
		if collision.collider.has_method("collect"):
			game_position = collision.collider.collect()
			sheet = collision.collider
			steps = sheet.get_steps()
			next_step = steps[s]

			game_mode()
	if pulling:
		box.move(velocity, delta, global_position)
#===================================================================
func game_mode_physics(delta):

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
			velocity = move_and_slide(direction.normalized() * 100)
	elif jumping_steps:
		if read_input:
			var direction = Vector2()
			direction = (next_step - global_position)
			velocity = move_and_slide(Vector2(direction.x * 15, direction.y * 5))
	else:
		velocity = move_and_slide(velocity, Vector2(0,-1))
		collision = move_and_collide(velocity * delta)	
		
	if Input.is_action_just_pressed("ui_cancel"):
		read_input = true
		action = "idle"
		action_shape = idle
#===================================================================	
func _physics_process(delta):

	velocity.y += gravity * delta
	if !jumping_steps:
		velocity.x = 0
	if read_input:
		get_input()
	if !game_mode:
		normal_physics(delta)
	if game_mode:
		game_mode_physics(delta)
	
	animations.play(action)
	#handle_collision_shapes(action_shape)
		
#===================================================================
func _on_animations_animation_finished():
	if action == "jump":
		read_input = true
	pass # replace with function body
#===================================================================
func _on_jump_timer_timeout():
	velocity.y = jump_speed
	pass # replace with function body
#===================================================================
func game_mode():
	action = "run"
	action_shape = run
	get_node("Camera2D").drag_margin_bottom = 1
	get_node("Camera2D").drag_margin_top = 0
	game_mode = true


func _on_jump_stairs_timer_timeout():
	jumping_steps = false
	if s == 4:
		game_mode = false
		s = 0 
	else:
		s += 1
		next_step = steps[s]
