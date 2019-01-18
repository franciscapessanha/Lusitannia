extends StaticBody2D

onready var left  = get_parent().get_node("Arrows/left")
onready var up  = get_parent().get_node("Arrows/up")
onready var down  = get_parent().get_node("Arrows/down")
onready var right  = get_parent().get_node("Arrows/right")

onready var note1 = get_node("note1")
onready var note2 = get_node("note2")
onready var note3 = get_node("note3")
onready var note4 = get_node("note4")

onready var seq_notes = [note1, note2, note3, note4]
onready var seq_arrows = [left, up, down, right]  
onready var seq_len = [400, 400, 400, 400]

onready var wrong = get_node("wrong")
onready var collect = get_node("collect")
var try = ""
var truth = "LUDR"
var mode = "all"

func _ready():
	set_process(false)
func get_input():
	if Input.is_action_just_pressed("ui_left"):
		try = try + "L"
		play_note1()
	elif Input.is_action_just_pressed("ui_up"):
		play_note2()
		try = try + "U"
	elif Input.is_action_just_pressed("ui_down"):
		play_note3()	
		try = try + "D"
	elif Input.is_action_just_pressed("ui_right"):
		play_note4()
		try = try + "R"

func _process(delta):
	get_input()
	if try.length() == truth.length():
		if try == truth:
			get_parent().get_node("Bard").set_exploring()
			collect.start()
			set_process(false)
		else:
			try = ""
			wrong.start()
	
func play_song():
	mode = "all"
	set_process(false)
	play_note1()

func play_note1():
	seq_arrows[0].play("on")
	seq_notes[0].play()		

func _on_note1_finished():
	seq_arrows[0].play("off")
	if mode == "all":
		play_note2()
		print("note1")

func play_note2():
	seq_arrows[1].play("on")
	seq_notes[1].play()	

func _on_note2_finished():
	seq_arrows[1].play("off")	
	if mode == "all":
		play_note3()
		print("note2")

func play_note3():
	seq_arrows[2].play("on")
	seq_notes[2].play()		

func _on_note3_finished():
	seq_arrows[2].play("off")
	if mode == "all":
		play_note4()
		print("note3")

func play_note4():
	seq_arrows[3].play("on")
	seq_notes[3].play()		

func _on_note4_finished():
	seq_arrows[3].play("off")
	if mode == "all":
		set_process(true)
		mode = "try"
		print("note4")


func _on_wrong_timeout():
	play_song()
	pass # replace with function body


func _on_collect_timeout():
	queue_free()
	pass # replace with function body
