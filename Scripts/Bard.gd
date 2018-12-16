extends KinematicBody2D

var velocity = Vector2(0,0)
var exploring = true
func _ready():
	get_parent().get_node("select").hide()
	get_parent().get_node("escape").hide()
	pass

func get_input():
	if Input.is_action_pressed("ui_right"):
		velocity.x = 200
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -200
	elif Input.is_action_pressed("ui_up"):
		velocity.y = -400	

func get_sheet():
	if get_parent().get_node("Sheet").global_position.distance_to(global_position) < 200:
		get_parent().get_node("select").show()
		if Input.is_action_just_pressed("ui_select"):
			get_parent().get_node("Sheet").play_song()
			exploring = false
			get_parent().get_node("select").hide()
	else:
		get_parent().get_node("select").hide()
		
func _process(delta):
	velocity.y = (50 + velocity.y)
	velocity.x = 0
	
	if exploring:
		get_input()
		var collision = move_and_slide(velocity)
		get_sheet()
	else:
		get_parent().get_node("escape").show()
		if Input.is_action_just_pressed("ui_select"):
			get_parent().get_node("Sheet").set_process(false)
			exploring = true
			get_parent().get_node("escape").hide()
			
		
	

	
	

	
