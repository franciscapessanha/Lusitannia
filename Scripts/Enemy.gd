extends KinematicBody2D

onready var initial_position = get_node("initial_position").global_position
onready var final_position = get_node("final_position").global_position
onready var target_position = final_position

var run_speed = 350

onready var walk = get_node("walk_collision")
onready var attack = get_node("attack_collision")
onready var actions = [walk, attack]
onready var animations = get_node("animations")
onready var head = get_node("head").global_position
var action = "walk"
var action_shape = walk
var walking = true
var direction = Vector2()
var i = 0
var killed = false


func _ready():
	global_position.x = initial_position.x
	global_position.y = 600
	
func handle_collision_shapes(action):
	if !killed:
		for i in range(len(actions)):
			if action == actions[i]:
				actions[i].disabled = false
			else:
				actions[i].disabled = true

func collision_with_enemy(position):
	if !killed:
		if abs(position.y - head.y) < 10:
			enemy_killed()
		else:
			get_parent().get_node("Bard").lost_life("enemy", actions)
	
func attack():
	action = "attack"
	action_shape = attack
	move_and_slide(Vector2(1,0) * run_speed*6)
	animations.play(action)
	handle_collision_shapes(action_shape)

func _physics_process(delta):
	var collision = move_and_collide(direction * delta)
	if collision and collision.collider.has_method("lost_life"):
		get_parent().get_node("Bard").lost_life("enemy", actions)
	if walking and !killed:
		direction.x = (target_position.x - global_position.x)
		direction.y = 10
		move_and_slide(direction.normalized() * run_speed)
		action = "walk"
		action_shape = walk
		animations.play(action)
		if global_position.x > 0.95*target_position.x and global_position.x < 1.05*target_position.x:
			if target_position == final_position:
				target_position = initial_position
				walking = false		
				attack()
			else:
				target_position = final_position
				walking = false		
				attack()

func _on_animations_animation_finished():
	if action == "attack":
		move_and_slide(Vector2(-1,0) * run_speed*6)
		walking = true
		action_shape = walk
		handle_collision_shapes(action_shape)
		if target_position == initial_position:
			animations.set_flip_h(true)
		else:
			animations.set_flip_h(false)
	if killed:
		animations.visible = false
		set_physics_process(false)

func enemy_killed():
	animations.play("killed")
	for i in range(len(actions)):
		actions[i].disabled = true
	killed = true