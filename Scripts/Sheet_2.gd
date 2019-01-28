extends StaticBody2D
"""
Global Variables
===================================================================
"""
onready var collision = get_node("collision")
onready var sprite = get_node("sprite")
onready var mug = preload("res://Scenes/Mug_movements.tscn")
onready var sequency = ["C", "A", "G", "A", "B", "A"] #Letters correspond to the correct note
onready var notes = [get_parent().get_node("notes_2/note_0"),
get_parent().get_node("notes_2/note_1"),
get_parent().get_node("notes_2/note_2"),
get_parent().get_node("notes_2/note_3"), 
get_parent().get_node("notes_2/note_4"), 
get_parent().get_node("notes_2/note_5")]

var i = -1
var wrong = false

"""
Collect melody sheet
===================================================================
"""
func collect_melody():
	collision.disabled = true
	sprite.hide()
	generate_next_mug()

"""
Reset rhythm sheet
===================================================================
"""
func reset_melody():
	collision.disabled = false
	sprite.show()

func _ready():
	set_process(false)

"""
Generate next mug
===================================================================
It will generate a new mug if the sequence didn't end.
"""
func generate_next_mug():
	i += 1
	set_process(true)
	if i < len(sequency):
		var new_mug = mug.instance()
		add_child(new_mug)
		new_mug.change_label(sequency[i])
	else:
		if !wrong:
			get_parent().get_node("fight").change_animation("cheers")
			get_parent().get_node("barman").change_animation("happy")
			get_parent().get_node("fight/fight_collision").disabled = true
			get_parent().get_parent().get_node("Bard").change_mode("exploring")
			get_parent().get_parent().get_node("sounds/2_melody").play()
			get_parent().get_parent().get_node("sounds/background").play()
			get_parent().get_parent().get_node("sounds/1_rhythm").stop()
		else:
			wrong = false
			i = -1
			var new_mug = mug.instance()
			add_child(new_mug)
			new_mug.change_label(sequency[i])


"""
Gets input
===================================================================
"""
func get_input():
	if i < len(sequency):
		if Input.is_action_just_pressed("La"):
			if sequency[i] != "A":
				wrong = true
			play_note("A")
			print(sequency[i])
			print("wrong ", wrong)
		if Input.is_action_just_pressed("Si"):
			if sequency[i] != "B":
				wrong = true
			play_note("B")
			print(sequency[i])
			print("wrong ", wrong)
		if Input.is_action_just_pressed("Do"):
			if sequency[i] != "C":
				wrong = true
			play_note("C")
			print(sequency[i])
			print("wrong ", wrong)
		if Input.is_action_just_pressed("Mi"):
			if sequency[i] != "E":
				wrong = true
			play_note("E")
			print(sequency[i])
			print("wrong ", wrong)
		if Input.is_action_just_pressed("Fa"):
			if sequency[i] != "F":
				wrong = true
			play_note("F")
			print(sequency[i])
			print("wrong ", wrong)
		if Input.is_action_just_pressed("Sol"):
			if sequency[i] != "G":
				wrong = true
			play_note("G")
			print(sequency[i])
			print("wrong ", wrong)

"""
Play Note
===================================================================
"""
func play_note(note):
	if note == "A":
		notes[0].play()
	if note == "B":
		notes[1].play()
	if note == "C":
		notes[2].play()
	if note == "D":
		notes[3].play()
	if note == "E":
		notes[4].play()
	if note == "F":
		notes[5].play()
	if note == "G":
		notes[5].play()

"""
Process function
===================================================================
"""
func _process(delta):
	get_input()


