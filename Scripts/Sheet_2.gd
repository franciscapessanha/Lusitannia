extends StaticBody2D

onready var collision = get_node("collision_2")
onready var sprite = get_node("sprite")
onready var mug = preload("res://Scenes/Mug_movements.tscn")
onready var sequency = ["A", "S", "D", "J", "K", "L"]
var i = 0
var try = ""
var ground_truth = "ASDJKL"	
func collect_melody():
	collision.disabled = true
	sprite.hide()
	#print("initial_position",get_node("initial_position").global_position)
	#return get_node("initial_position").global_position

func generate_next_mug():
	if i < len(sequency):
		var new_mug = mug.instance()
		add_child(new_mug)
		new_mug.change_label(sequency[i])
		i += 1
	else:
		i = 0
		if try == ground_truth:
			get_parent().get_node("Fight").change_animation("cheers")
			get_parent().get_node("Barman").change_animation("happy")
			get_parent().get_node("Fight/fight_collision").disabled = true
			get_parent().get_node("Bard").change_mode("exploring")
			get_node("final").play()
		else:
			
			var new_mug = mug.instance()
			add_child(new_mug)
			new_mug.change_label(sequency[i])

func get_input():
	if Input.is_action_just_pressed("A_key"):
		try = try + "A"
		play_note("A")
	if Input.is_action_just_pressed("S_key"):
		try = try + "S"
		play_note("S")
	if Input.is_action_just_pressed("D_key"):
		try = try + "D"
		play_note("D")
	if Input.is_action_just_pressed("J_key"):
		try = try + "J"
		play_note("J")
	if Input.is_action_just_pressed("K_key"):
		try = try + "K"
		play_note("K")
	if Input.is_action_just_pressed("L_key"):
		try = try + "L"
		play_note("L")

func _process(delta):
	get_input()

func play_note(note):
	if note == "A":
		print("tocar A")
	if note == "S":
		print("tocar S")
	if note == "D":
		print("tocar D")
	if note == "J":
		print("tocar J")
	if note == "K":
		print("tocar K")
	if note == "L":
		print("tocar L")