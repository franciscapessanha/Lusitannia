extends KinematicBody2D

var velocity = Vector2(0,0)
var exploring = true
var find_sheet = true

func _ready():
	get_parent().get_node("select").hide()
	get_parent().get_node("escape").hide()
	pass

func get_input():
	if Input.is_action_pressed("ui_right"):
		velocity.x = 200
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -200
	elif Input.is_action_just_pressed("ui_up"):
		velocity.y = -600	

func get_sheet():
	if get_parent().get_node("Sheet").global_position.distance_to(global_position) < 200:
		get_parent().get_node("select").show()
		if Input.is_action_just_pressed("ui_select"):
			get_parent().get_node("Sheet").play_song()
			get_parent().get_node("select").hide()
	else:
		get_parent().get_node("select").hide()
		
func _process(delta):
	velocity.y = (20 + velocity.y)
	velocity.x = 0
	
	if exploring:
		get_input()
		var collision = move_and_slide(velocity)
		if find_sheet:
			get_sheet()
	else:
		get_parent().get_node("escape").show()
		if Input.is_action_just_pressed("ui_select"):
			get_parent().get_node("Sheet").set_process(false)
			exploring = true
			get_parent().get_node("escape").hide()
		
func set_exploring():
	exploring = true
	find_sheet = false
	get_parent().get_node("escape").hide()

	
	