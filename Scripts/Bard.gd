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

#Motion parameters
var velocity = Vector2(0,0)
var run_speed = 250
var gravity = 1250
var jump_speed = -500
var crawling = false
var pulling = false

func _ready():	
	animations.play(action)
	handle_collision_shapes(action_shape)
	set_physics_process(true)
	pass

func handle_collision_shapes(action):
	for i in range(len(actions)):
		if action == actions[i]:
			actions[i].disabled = false
		else:
			actions[i].disabled = true
			
	
func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var up = Input.is_action_just_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")

	if is_on_floor() and up:
		if crawling:
			action = "idle"
			action_shape = idle
		else:
			action = "jump"	
			action_shape = jump
			jump_timer.start()
			read_input = false
		crawling = false
	elif right:
		velocity.x += run_speed
		animations.set_flip_h(false)
		if !crawling and !pulling:
			action = "run"
			action_shape = run	
	elif left:
		velocity.x -= run_speed
		animations.set_flip_h(true)
		if !crawling and !pulling:
			action = "run"
			action_shape = run		
	elif is_on_floor() and down:
		action = "crawl"
		action_shape = crawl
		crawling = true
	else:
		if !crawling and !pulling:
			action = "idle"
			action_shape = idle
	
func _physics_process(delta):
	velocity.y += gravity * delta
	if read_input:
		get_input()
	velocity = move_and_slide(velocity, Vector2(0,-1))
	var collision = move_and_collide(velocity * delta)
	if collision:
		if  collision.collider.has_method("collided"):
			action = "pull"
			action_shape = pull
			var position_collider = collision.collider.global_position
			pulling = true
	animations.play(action)
	

func _on_animations_animation_finished():
	if action == "jump":
		read_input = true
	pass # replace with function body


func _on_jump_timer_timeout():
	velocity.y = jump_speed
	pass # replace with function body
