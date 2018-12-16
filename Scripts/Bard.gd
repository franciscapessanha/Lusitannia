extends KinematicBody2D

var velocity = Vector2(0,0)

func _ready():
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
		get_parent().get_node("Note").show()
		if Input.is_action_just_pressed("ui_select"):
			get_parent().get_node("Sheet").play_song()
			
		get_parent().get_node("Note").hide()
		
func _process(delta):
	velocity.y = (50 + velocity.y)
	velocity.x = 0
	get_input()
	get_sheet()
	var collision = move_and_slide(velocity)

	
